class_name Corpse
extends CharacterBody2D

const MAX_SLIDES: int = 8

@export_group("Bounce", "bounce")
@export var bounce_factor: float = 0.7
@export var bounce_min_velocity: float = 150.0

@export var x_decel: float = 50.0
@export var slide_friction: float = 0.5
@export var drag: float = 10.0

var _last_normal: Vector2 = Vector2.ONE * NAN

@onready var _sprite: AnimatedSprite2D = $Sprite2D


## Public API used to knock the corpse around.
## [param vec] should not be multiplied by delta.
##
## Velocity *may* be overridden. It is guaranteed that resulting velocity will be at least vec.
func apply_impulse(vec: Vector2) -> void:
	if signf(velocity.x) == signf(vec.x):
		velocity.x = signf(vec.x) * maxf(absf(vec.x), absf(velocity.x))
	else:
		velocity.x = vec.x
	if signf(velocity.y) == signf(vec.y):
		velocity.y = signf(vec.y) * maxf(absf(vec.y), absf(velocity.y))
	else:
		velocity.y = vec.y


func _ready() -> void:
	_sprite.flip_h = randi() % 2 == 0


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta

	velocity.x = move_toward(velocity.x, 0, x_decel * delta)

	velocity = velocity.move_toward(Vector2.ZERO, drag * delta)
	var time: float = delta

	_last_normal = Vector2.ONE * NAN
	for i: int in MAX_SLIDES:
		var travel: Vector2 = velocity * time
		if travel.is_zero_approx():
			break

		var col: KinematicCollision2D = move_and_collide(travel)
		if col == null:
			break

		_last_normal = col.get_normal()

		time *= col.get_remainder().length() / travel.length()

		var st := CorpseSpiked.get_spike_collision_type(col)
		if st != CorpseSpiked.SpikeType.NONE:
			queue_free()
			match st:
				CorpseSpiked.SpikeType.NORMAL:
					CorpseSpiked.spawn(get_parent(), col.get_normal(), col.get_position())
				CorpseSpiked.SpikeType.CURSED:
					print("corpse hit cursed spike")
			return

		var normal: Vector2 = col.get_normal()
		var projection: Vector2 = velocity.project(normal)

		if projection.length_squared() <= _sq(bounce_min_velocity):
			# eat this bounce
			velocity -= projection
			continue

		var bounce: Vector2 = -velocity.project(normal) * bounce_factor
		var slide: Vector2 = velocity.slide(normal) * slide_friction

		velocity = bounce + slide

	_update_animations()


func _sq(f: float) -> float:
	return f * f


func _update_animations() -> void:
	if not _last_normal.is_finite() or absf(_last_normal.angle_to(Vector2.UP)) > PI * 0.25:
		# airborne / wall collision
		if velocity.y > 0:
			_sprite.play("fall")
		else:
			_sprite.play("jump")
	else:
		_sprite.play(&"idle")
