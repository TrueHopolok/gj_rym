extends Area2D

@export_file_path("*.tscn") var _next_lvl: String

@onready var _door: Sprite2D = %Door
@onready var _base: Sprite2D = %Base
@onready var _light: Sprite2D = %Light
@onready var _exit_position: Marker2D = %ExitPosition


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

	_do_exit_sequence(player)


func _exited() -> void:
	if !FileAccess.file_exists(_next_lvl):
		Transition.reload_scene()
	else:
		Transition.change_scene_path(_next_lvl)


func _do_exit_sequence(player: Player) -> void:
	print("exit seq")
	player.state = Player.PLAYER_STATES.BUSY

	var t: Tween = create_tween().chain()
	t.tween_property(player, "global_position", _exit_position.global_position, 0.5)
	t.tween_property(_door, "position", Vector2.UP * 64, 1).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(_light, "modulate:a", 1.0, 1)
	t.chain().tween_callback(func () -> void:
		player.z_index -= 1
	)
	t.chain().tween_interval(1.0)
	t.chain().tween_property(_door, "position", Vector2.DOWN * 64, 2).as_relative().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	t.tween_callback(_exited)
