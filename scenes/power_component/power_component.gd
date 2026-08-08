class_name PowerComponent
extends Node2D

signal power_state_changed(is_powered: bool)
signal on_powered_on
signal on_powered_off

var _state: bool


func is_powered() -> bool:
	return _state


func set_powered(p: bool) -> void:
	if p == _state:
		return

	_state = p
	_on_power_state_changed(_state)
	power_state_changed.emit(_state)
	if _state:
		_on_powered_on()
		on_powered_on.emit()
	else:
		_on_powered_off()
		on_powered_off.emit()


func _on_powered_on() -> void:
	pass


func _on_powered_off() -> void:
	pass


func _on_power_state_changed(_s: bool) -> void:
	pass
