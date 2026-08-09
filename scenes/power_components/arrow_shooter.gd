@tool
class_name ArrowShooter
extends PowerComponent

const ARROW: PackedScene = preload("res://scenes/arrow/arrow.tscn")

@export_group("Timer", "timer")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var timer_enable: bool = false
@export var timer_interval: float = 2.0

@export var direction: int = 0:
	set(v):
		direction = v
		_update_direction()
@export_tool_button("Rotate 90 degrees") var action_rotate: Callable = func() -> void: direction = (direction + 1) % 4

@onready var _spawn_marker: Node2D = %SpawnMarker

@export var arrow_velocity: float = 400.0


func _ready() -> void:
	_update_direction()

	if Engine.is_editor_hint():
		return

	if timer_enable:
		var t: Timer = Timer.new()
		add_child(t)

		t.start(timer_interval)

		t.timeout.connect(_on_powered_on)


func _on_powered_on() -> void:
	if Engine.is_editor_hint():
		return

	var arrow: Arrow = ARROW.instantiate()
	get_parent().add_child(arrow)

	arrow.global_position = _spawn_marker.global_position
	arrow.global_rotation = _spawn_marker.global_rotation
	arrow.velocity = Vector2.from_angle(global_rotation) * arrow_velocity


func _update_direction() -> void:
	($Arrowbox as Sprite2D).frame = direction
