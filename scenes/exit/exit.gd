extends Area2D


@export_file_path("*.tscn") var _next_lvl: String


func _ready() -> void:
	body_entered.connect(_exit)


func _exit(body: PhysicsBody2D) -> void:
	var player: Player = body as Player
	if !is_instance_valid(player):
		return
	set_deferred("monitoring", false)
	set_deferred("monitoriable", false)
	player.global_position = global_position
	player.exited.connect(_exited)
	player.exit()


func _exited() -> void:
	if !FileAccess.file_exists(_next_lvl):
		Transition.reload_scene()
	else:
		Transition.change_scene_path(_next_lvl)
