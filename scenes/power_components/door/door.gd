class_name Door
extends PowerComponent
@onready var animatable_body_2d: AnimatableBody2D = %Body

const H: float = 96 - 10

var _initial_pos_y: float


func _ready() -> void:
	_initial_pos_y = animatable_body_2d.position.y


func _on_powered_on() -> void:
	var t: Tween = ( animatable_body_2d. create_tween()
			.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
			.set_trans(Tween.TRANS_CUBIC)
			.set_ease(Tween.EASE_IN_OUT))
	t.tween_property(animatable_body_2d, "position:y", _initial_pos_y - H, 1.0)


func _on_powered_off() -> void:
	var t: Tween = ( animatable_body_2d. create_tween()
			.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
			.set_trans(Tween.TRANS_BOUNCE)
			.set_ease(Tween.EASE_OUT))
	t.tween_property(animatable_body_2d, "position:y", _initial_pos_y, 1.0)
