class_name PainExit
extends Exit

enum PainType {
	LEFT,
	RIGHT,
	FINAL,
}

@export var _type: PainType

var _anim: Tween = null

@onready var _label: Label = $Warning


func _ready() -> void:
	if _type == PainType.FINAL:
		var is_open: bool = Persistence.pain_left && Persistence.pain_right
		if is_open:
			super()
			_light.modulate.a = 1.0
		else:
			body_entered.connect(_unavailable)
	else:
		super()
		if (
			(_type == PainType.LEFT && Persistence.pain_left)
			|| (_type == PainType.RIGHT && Persistence.pain_right)
		):
			_light.modulate.a = 1.0


func _submit_score() -> void:
	pass


func _unavailable(body: PhysicsBody2D) -> void:
	if !is_instance_valid(body as Player):
		return
	if is_instance_valid(_anim) && _anim.is_valid() && _anim.is_running():
		_anim.kill()
	_anim = create_tween().chain()
	_anim.tween_property(_label, "modulate:a", 1.0, 0.25)
	_anim.chain().tween_property(_label, "modulate:a", 0.0, 5.0)
