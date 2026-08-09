extends Area2D

@export_file_path("*.tscn") var _next_lvl: String
@export var is_sarco: bool = false

@onready var _door: Sprite2D = %Door
@onready var _light: Sprite2D = %Light
@onready var _exit_position: Marker2D = %ExitPosition
@onready var _sfx_door: AudioStreamPlayer = $SFXDoor


func _ready() -> void:
	body_entered.connect(_exit)


func _exit(body: PhysicsBody2D) -> void:
	var player: Player = body as Player
	if !is_instance_valid(player):
		return

	set_deferred("monitoring", false)
	set_deferred("monitoriable", false)

	Persistence.current_level += 1
	Persistence.submit()

	if is_sarco:
		_do_exit_sequence_ded(player)
	else:
		_do_exit_sequence_door(player)


func _exited() -> void:
	if !FileAccess.file_exists(_next_lvl):
		Transition.reload_scene()
	else:
		Transition.change_scene_path(_next_lvl)


func _do_exit_sequence_door(player: Player) -> void:
	player.state = Player.PLAYER_STATES.BUSY

	_sfx_door.play()
	var t: Tween = create_tween().chain()
	t.tween_property(player, "global_position", _exit_position.global_position, 0.5)
	t.tween_property(_door, "position", Vector2.UP * 64, 0.9).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN
	)
	t.parallel().tween_property(_light, "modulate:a", 1.0, 1)
	t.chain().tween_callback(func() -> void: player.z_index -= 1)
	t.chain().tween_interval(1.0)
	t.chain().tween_callback(_sfx_door.play)
	(
		t
		. chain()
		. tween_property(_door, "position", Vector2.DOWN * 64, 0.9)
		. as_relative()
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN)
	)

	t.tween_callback(_exited)


func _do_exit_sequence_ded(player: Player) -> void:
	var base: Sprite2D = %Base
	var lid: Sprite2D = %Lid
	var text: RichTextLabel = %Text

	player.state = Player.PLAYER_STATES.BUSY

	var t: Tween = create_tween().chain()
	t.tween_property(player, "global_position", _exit_position.global_position, 0.5)
	t.tween_callback(
		func() -> void:
			player.hide()
			base.frame += 1
	)
	t.tween_interval(2.0)
	t.tween_callback(_sfx_door.play)
	t.tween_property(lid, "global_position", base.global_position, 1.5).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)
	t.tween_property(text, "visible_ratio", 0.74, 1)
	t.tween_interval(1.0)
	t.tween_property(text, "visible_ratio", 1, 1)
	t.tween_callback(_exited).set_delay(3.0)
