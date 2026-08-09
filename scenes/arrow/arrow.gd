class_name Arrow
extends CharacterBody2D

const PHYSICS_ENV_LAYER: int = 1

var _dist: float = 0.0


func _ready() -> void:
	assert(collision_mask & PHYSICS_ENV_LAYER != 0, "arrow has no intersection with environment")
	collision_mask &= ~PHYSICS_ENV_LAYER


func _physics_process(_delta: float) -> void:
	if move_and_slide():
		for i: int in get_slide_collision_count():
			var body: Node2D = get_slide_collision(i).get_collider()
			var pl: Player = body as Player
			if is_instance_valid(pl):
				pl.die()
		queue_free()

	_dist += get_position_delta().length()
	if _dist > 24:
		_dist = NAN
		(func() -> void: collision_mask |= PHYSICS_ENV_LAYER).call_deferred()
