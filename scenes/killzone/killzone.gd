extends Area2D


func _ready() -> void:
	body_entered.connect(_kill)


func _kill(body: PhysicsBody2D) -> void:
	var player: Player = body as Player
	if !is_instance_valid(player):
		return
	player.permadeath()