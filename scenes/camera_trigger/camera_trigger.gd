@tool
class_name CameraTrigger
extends Area2D

const VIEWPORT_SIZE: Vector2 = CustomCamera.VIEWPORT_SIZE

@export var debug_draw: bool = false
@export var debug_color: Color = Color(0.18039216, 0.54509807, 0.34117648, 0.5)

@export_custom(PROPERTY_HINT_LINK, "") var zoom: Vector2 = Vector2.ONE


func _draw() -> void:
	if not Engine.is_editor_hint() or not debug_draw:
		return

	var size: Vector2 = VIEWPORT_SIZE / zoom
	draw_rect(Rect2(-size * 0.5, size), debug_color, false)
	draw_multiline(
		PackedVector2Array(
			[
				-size * 0.5,
				size * 0.5,
				size * Vector2(0.5, -0.5),
				size * Vector2(-0.5, 0.5),
			]
		),
		debug_color
	)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	body_entered.connect(
		func(_b: Node2D) -> void: get_tree().call_group(&"custom_camera", "trigger_on", self)
	)

	body_exited.connect(
		func(_b: Node2D) -> void: get_tree().call_group(&"custom_camera", "trigger_off", self)
	)
