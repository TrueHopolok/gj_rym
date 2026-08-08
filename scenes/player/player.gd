class_name Player
extends CharacterBody2D

signal died
signal exited

enum PLAYER_STATES {
	BUSY = 10,  # used for cutscenes / manual control
	DIED = 20,
	IDLE = 30,
	MOVE = 40,
	JUMP = 50,
}

const PLAYER_STATES_TO_STRING: Dictionary[int, String] = {
	PLAYER_STATES.BUSY: "BUSY",
	PLAYER_STATES.DIED: "DIED",
	PLAYER_STATES.IDLE: "IDLE",
	PLAYER_STATES.MOVE: "MOVE",
	PLAYER_STATES.JUMP: "JUMP",
}

const KICK_FORCE: Vector2 = Vector2(400, 300)
const RUN_FORCE: float = 900.0
const JUMP_FORCE: float = 400.0
const POGO_FORCE: float = 450.0
const MEGA_FORCE: float = 500.0
const MAX_RUNNING_SPEED: float = 250.0
const MAX_FALLING_SPEED: float = 500.0
const BUFFER_JUMP_LENGTH: float = 0.05
const BUFFER_COYOTE_LENGTH: float = 0.20
const BUFFER_MEGA_LENGTH: float = 0.10

const CORPSE: PackedScene = preload("res://scenes/corpse/corpse.tscn")
const CORPSE_POGO_VELOCITY: float = 450.0

var _has_cancel: bool = false

var state: PLAYER_STATES = PLAYER_STATES.IDLE

@onready var _debug_state_label: Label = $DebugStateLabel
@onready var _buffer_jump: Timer = $BufferJump
@onready var _buffer_mega: Timer = $BufferMega
@onready var _buffer_coyote: Timer = $BufferCoyote
@onready var _kick_area: Area2D = %KickArea


func _ready() -> void:
	_kick_area.body_entered.connect(_handle_kick)
	_kick_area.area_entered.connect(_handle_kick)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		_buffer_jump.start(BUFFER_JUMP_LENGTH)


func _physics_process(delta: float) -> void:
	if state <= PLAYER_STATES.DIED:
		return
	for i: int in get_slide_collision_count():
		var col: KinematicCollision2D = get_slide_collision(i)
		if CorpseSpiked.is_spike_collision(col):
			_spike_death(col.get_position(), col.get_normal())
			break
	_resistance_horizontal()
	_resistance_vertical(delta)
	_movement_horizontal(delta)
	_movement_pogo()
	_movement_jump()
	_update_state()
	if OS.is_debug_build() && get_tree().debug_collisions_hint:
		_debug_state_label.text = PLAYER_STATES_TO_STRING[state]
	move_and_slide()


func _resistance_horizontal() -> void:
	var input_dir: float = Input.get_axis(&"left", &"right")
	if input_dir != 0:
		return
	velocity.x = 0.0


func _movement_horizontal(delta: float) -> void:
	var input_dir: float = Input.get_axis(&"left", &"right")
	if input_dir == 0:
		return
	if input_dir != sign(velocity.x):
		velocity.x = 0.0
	velocity.x = clampf(velocity.x + input_dir * delta * RUN_FORCE, -MAX_RUNNING_SPEED, MAX_RUNNING_SPEED)


func _resistance_vertical(delta: float) -> void:
	if is_on_floor():
		_has_cancel = false
		_buffer_coyote.start(BUFFER_COYOTE_LENGTH)
		return
	velocity.y = minf(velocity.y + delta * get_gravity().y, MAX_FALLING_SPEED)
	if velocity.y < 0.0 && _has_cancel && Input.is_action_just_released(&"jump"):
		_has_cancel = false
		velocity.y *= 0.4
	if velocity.y > 0.0:
		_has_cancel = false
		velocity.y = minf(velocity.y + delta * get_gravity().y, MAX_FALLING_SPEED)


func _movement_pogo() -> void:
	for i: int in get_slide_collision_count():
		var corpse: Corpse = get_slide_collision(i).get_collider() as Corpse
		if !is_instance_valid(corpse):
			continue
		# todo: check corpse being static
		var force: float = POGO_FORCE
		_buffer_coyote.stop()
		if !_buffer_jump.is_stopped():
			_buffer_jump.stop()
			force = MEGA_FORCE
			print("MEGA")
		else:
			_buffer_mega.start(BUFFER_MEGA_LENGTH)
		velocity.y = -force


func _movement_jump() -> void:
	if _buffer_jump.is_stopped():
		return
	if !_buffer_mega.is_stopped():
		_buffer_jump.stop()
		_buffer_mega.stop()
		_has_cancel = true
		velocity.y = -MEGA_FORCE
		print("MEGA")
		return
	if !is_on_floor() && _buffer_coyote.is_stopped():
		return
	_buffer_jump.stop()
	_buffer_coyote.stop()

	_has_cancel = true
	velocity.y = -JUMP_FORCE  # weak mega


func _update_state() -> void:
	if !is_on_floor():
		state = PLAYER_STATES.JUMP
	elif not is_zero_approx(velocity.x):
		state = PLAYER_STATES.MOVE
	else:
		state = PLAYER_STATES.IDLE


func _handle_kick(col: Object) -> void:
	var corpse: Corpse = col as Corpse
	if not is_instance_valid(corpse):
		return

	var dir: float = signf(corpse.global_position.x - global_position.x)
	var vel: Vector2 = KICK_FORCE * Vector2(dir, 1)
	corpse.apply_impulse(vel)

	add_collision_exception_with(corpse)
	get_tree().create_timer(0.5).timeout.connect(remove_collision_exception_with.bind(corpse))


func _spike_death(pos: Vector2, normal: Vector2) -> void:
	queue_free()
	CorpseSpiked.spawn(get_parent(), normal, pos)
	died.emit()


func die() -> void:
	queue_free()
	var inst: Corpse = CORPSE.instantiate()
	get_parent().add_child(inst)
	inst.global_position = global_position
	inst.velocity = velocity
	died.emit()


func spawn() -> void:
	print("I AM SPAWNING")


func exit() -> void:
	print("I AM EXITING")
	exited.emit()
