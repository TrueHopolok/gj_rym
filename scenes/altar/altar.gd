@tool
class_name Altar
extends Node2D

signal player_spawned(p: Player)

@export var spawn_on_ready: bool = true
@export var spawn_player_state: Player.PLAYER_STATES = Player.PLAYER_STATES.IDLE
@export var initial_modulate: Color = Color(Color.YELLOW, 0.0)

@export var _player: PackedScene
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _sfx_altar: AudioStreamPlayer = $SFXAltar


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(is_instance_valid(_player), "WTH man, who do I spawn")

	_animation_player.animation_finished.connect(func (_anim: StringName) -> void:
		if get_tree().get_node_count_in_group(&"player") == 0:
			spawn.call_deferred()
	)

	if spawn_on_ready:
		spawn()


func spawn() -> void:
	_animation_player.play(&"revive")
	_sfx_altar.play()


func _spawn_player() -> void:
	var inst: Player = _player.instantiate() as Player
	inst.global_position = global_position
	inst.global_position.y -= 16  # yes, magic constant, but idc
	inst.died.connect(spawn, CONNECT_ONE_SHOT)
	inst.state = spawn_player_state

	inst.modulate = initial_modulate

	get_parent().add_child.call_deferred(inst)

	inst.create_tween().tween_property(inst, "modulate", Color.WHITE, 0.5)

	player_spawned.emit(inst)


func emit_particles() -> void:
	for child: Node in get_children():
		var p: CPUParticles2D = child as CPUParticles2D
		if is_instance_valid(p):
			p.emitting = true


func disown(p: Player) -> void:
	p.died.disconnect(spawn)
