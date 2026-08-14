@tool
class_name PainExit
extends Exit

@export var _lockable: bool = false
@export var _left: bool = false

var _anim: Tween = null

@onready var _label: Label = $Warning


func _ready() -> void:
	Persistence.pain_left = true
	if _lockable:
		var is_open: bool = Persistence.pain_left && Persistence.pain_right
		if is_open:
			super()
			_light.modulate.a = 1.0
		else:
			body_entered.connect(_unavailable)
	else:
		super()
		if _left && Persistence.pain_left:
			_light.modulate.a = 1.0
		elif !_left && Persistence.pain_right:
			_light.modulate.a = 1.0


func _unavailable(body: PhysicsBody2D) -> void:
	if !is_instance_valid(body as Player):
		return
	if is_instance_valid(_anim) && _anim.is_valid() && _anim.is_running():
		_anim.kill()
	_anim = create_tween().chain()
	_anim.tween_property(_label, "modulate:a", 1.0, 0.25)
	_anim.chain().tween_property(_label, "modulate:a", 0.0, 5.0)
