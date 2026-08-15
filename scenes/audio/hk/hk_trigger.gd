extends Area2D

@export var _stage: int = 5


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if !is_instance_valid(body as Player):
		return
	GlobalMusic.set_stage(_stage)
