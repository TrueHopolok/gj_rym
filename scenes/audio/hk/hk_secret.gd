extends Node

var _cur: Array[int] = [0, 0, 0, 0, 0, 0]
var _goal: Array[int] = [KEY_H, KEY_O, KEY_L, KEY_L, KEY_O, KEY_W]


func _ready() -> void:
	GlobalMusic.set_stage(1)


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	_cur.pop_front()
	_cur.push_back(key_event.keycode)
	if _cur == _goal:
		GlobalMusic.hk_toggle()
