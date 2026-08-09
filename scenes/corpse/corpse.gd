class_name Corpse
extends RigidBody2D

const MAX_SLIDES: int = 8

@export_group("Bounce", "bounce")
@export var bounce_factor: float = 0.7
@export var bounce_min_velocity: float = 150.0

@export var x_decel: float = 50.0
@export var slide_friction: float = 0.5
@export var drag: float = 10.0

@onready var _sprite: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	_sprite.flip_h = randi() % 2 == 0
	_sprite.animation_finished.connect(_sprite.play.bind(&"idle"))


func _physics_process(_delta: float) -> void:
	_update_animations()


func _sq(f: float) -> float:
	return f * f


func _update_animations() -> void:
	if _sprite.animation == &"bounce":
		return

	const MIN_VELOCITY: float = 100.0
	var velocity: Vector2 = linear_velocity
	if velocity.length_squared() < MIN_VELOCITY * MIN_VELOCITY:
		_sprite.play(&"idle")
	elif velocity.y > 0:
		_sprite.play("fall")
	else:
		_sprite.play("jump")


func _safe_bounce(vel: Vector2, n: Vector2) -> Vector2:
	if vel.dot(n) > 0:
		return vel
	return vel.bounce(n)


func play_bounce() -> void:
	_sprite.play("bounce")


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for idx: int in state.get_contact_count():
		var normal: Vector2 = state.get_contact_local_normal(idx)
		var collider: Object = state.get_contact_collider_object(idx)
		var pos: Vector2 = state.get_contact_collider_position(idx)
		var t: CorpseSpiked.SpikeType = CorpseSpiked.get_spike_collision_type(collider, pos, normal)
		match t:
			CorpseSpiked.SpikeType.NONE:
				pass
			CorpseSpiked.SpikeType.NORMAL:
				state.apply_impulse(state.get_contact_impulse(idx))
				queue_free()
				CorpseSpiked.spawn(get_parent(), normal, pos)
				return
			CorpseSpiked.SpikeType.CURSED:
				state.apply_impulse(state.get_contact_impulse(idx))
				queue_free()
				CorpseCursed.spawn(get_parent(), pos, state.linear_velocity)
				return
