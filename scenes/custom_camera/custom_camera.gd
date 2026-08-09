class_name CustomCamera
extends Camera2D

const VIEWPORT_SIZE: Vector2 = Vector2(640, 360)

var _current_player: Player
var _current_trigger: CameraTrigger


func _ready() -> void:
	_update_pos()
	reset_smoothing()


func _physics_process(_delta: float) -> void:
	_update_pos()


func _update_pos() -> void:
	if not is_instance_valid(_current_player):
		_current_player = get_tree().get_first_node_in_group(&"player")

	if _current_trigger != null:
		global_position = _current_trigger.global_position
	elif _current_player != null:
		global_position = _current_player.global_position

	for node: Node2D in get_tree().get_nodes_in_group(&"killzone"):
		global_position.y = minf(global_position.y, node.global_position.y - VIEWPORT_SIZE.y * 0.5 + 12)


func _animate_zoom(to: Vector2) -> void:
	create_tween().tween_property(self, "zoom", to, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func trigger_on(ct: CameraTrigger) -> void:
	assert(_current_trigger == null, "overlapping camera trigger")
	_current_trigger = ct
	_animate_zoom(ct.zoom)


func trigger_off(ct: CameraTrigger) -> void:
	assert(_current_trigger == ct)
	_current_trigger = null
	_animate_zoom(Vector2.ONE)
