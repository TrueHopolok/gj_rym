@tool
class_name Door
extends PowerComponent

@export var symbol: Symbol = Symbol.IOI_GATE:
	set(v):
		symbol = v
		_update_symbol()
@onready var _animatable_body_2d: AnimatableBody2D = %Body
@onready var _over: Sprite2D = %Over
@onready var _under: Sprite2D = %Under
@onready var _sfx_door: AudioStreamPlayer = $SFXDoor

const H: float = 96 - 10

var _initial_pos_y: float


func _ready() -> void:
	_update_symbol()

	if Engine.is_editor_hint():
		return

	_initial_pos_y = _animatable_body_2d.position.y


func _on_powered_on() -> void:
	var t: Tween = (
		_animatable_body_2d
		. create_tween()
		. set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_IN_OUT)
		. set_parallel()
	)
	_sfx_door.play()
	t.tween_property(_animatable_body_2d, "position:y", _initial_pos_y - H, 1.0)
	t.tween_property(_over, "modulate:a", 1.0, 1.0)


func _on_powered_off() -> void:
	var t: Tween = (
		_animatable_body_2d
		. create_tween()
		. set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		. set_trans(Tween.TRANS_BOUNCE)
		. set_ease(Tween.EASE_OUT)
		. set_parallel()
	)
	_sfx_door.play()
	t.tween_property(_animatable_body_2d, "position:y", _initial_pos_y, 1.0)
	t.tween_property(_over, "modulate:a", 0.0, 1.0)


func _update_symbol() -> void:
	if not is_inside_tree():
		return
	_over.frame = int(symbol)
	_under.frame = int(symbol)
