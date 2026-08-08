class_name Corpse
extends CharacterBody2D

@export_group("Bounce", "bounce")
@export var bounce_factor: float = 0.7
@export var bounce_min_velocity: float = 150.0

@export var x_decel: float = 50.0
@export var slide_friction: float = 0.95


## Public API used to knock the corpse around.
## [param vec] should not be multiplied by delta.
func apply_impulse(vec: Vector2) -> void:
	velocity += vec


const MAX_SLIDES: int = 8


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta

	velocity.x = move_toward(velocity.x, 0, x_decel * delta)

	for i: int in MAX_SLIDES:
		if velocity.is_zero_approx():
			break

		var col: KinematicCollision2D = move_and_collide(velocity * delta)
		if col == null:
			break

		var normal: Vector2 = col.get_normal()
		var projection: Vector2 = velocity.project(normal)

		if projection.length_squared() <= _sq(bounce_min_velocity):
			# eat this bounce
			velocity -= projection
			continue

		var bounce: Vector2 = -velocity.project(normal) * bounce_factor
		var slide: Vector2 = velocity.slide(normal) * slide_friction

		velocity = bounce + slide


func _sq(f: float) -> float:
	return f * f
