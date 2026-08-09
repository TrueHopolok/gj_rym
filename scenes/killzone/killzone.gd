extends Area2D

@onready var _sfx_death: AudioStreamPlayer = $SFXDeath


func _ready() -> void:
	body_entered.connect(_kill)


func _kill(body: PhysicsBody2D) -> void:
	var player: Player = body as Player
	if !is_instance_valid(player):
		return
	player.permadeath()
	get_tree().create_timer(0.1).timeout.connect(_sfx_death.play)
