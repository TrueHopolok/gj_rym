extends Node

var _cur: Array[int] = [0, 0, 0, 0]
var _goal: Array[int] = [KEY_P, KEY_A, KEY_I, KEY_N]


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	_cur.pop_front()
	_cur.push_back(key_event.keycode)
	if _cur == _goal:
		Persistence.current_level = -666
		Transition.change_scene_path("res://scenes/levels/pain/pain_intro.tscn")
