extends Area2D


func _ready() -> void:
	body_entered.connect(_exit)


func _exit(body: PhysicsBody2D) -> void:
	var player: Player = body as Player
	if !is_instance_valid(player):
		return
	set_deferred("monitoring", false)
	set_deferred("monitoriable", false)
	player.exited.connect(_exited)
	player.exit()


func _exited() -> void:
	print("He exited, switch sharmanka")
	Transition.reload_scene()
