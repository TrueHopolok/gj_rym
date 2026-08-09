class_name Arrow
extends CharacterBody2D


func _physics_process(_delta: float) -> void:
	if move_and_slide():
		for i: int in get_slide_collision_count():
			var body: Node2D = get_slide_collision(i).get_collider()
			var pl: Player = body as Player
			if is_instance_valid(pl):
				pl.die()
		queue_free()
