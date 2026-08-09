class_name CorpseCursed
extends Sprite2D

const SCENE: PackedScene = preload("res://scenes/corpse/corpse_cursed.tscn")

var velocity: Vector2
var damp: float = 1.0


static func spawn(parent: Node, pos: Vector2, vel: Vector2) -> void:
	var inst: CorpseCursed = SCENE.instantiate()
	vel *= 0.5

	parent.add_child(inst)
	inst.global_position = pos
	inst.velocity = vel
	inst.flip_h = randi() % 2 == 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animation.call_deferred()


func _animation() -> void:
	var t: Tween = create_tween()

	var m: ShaderMaterial = material
	t.tween_method(func(v: float) -> void: m.set_shader_parameter(&"progress", v), 1.0, -0.5, 1.5)
	t.parallel().tween_property(self, "damp", 0.0, 1.5)
	t.chain().tween_callback(queue_free)


func _physics_process(delta: float) -> void:
	const MAX_VELOCITY: float = 100.0
	if velocity.length_squared() > MAX_VELOCITY * MAX_VELOCITY:
		velocity = velocity.normalized() * MAX_VELOCITY
	global_position += velocity * delta * damp
