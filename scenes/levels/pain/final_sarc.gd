extends Sprite2D

@onready var sarcafac: Exit = %Sarcafac


func _ready() -> void:
	_set_progress(-100)
	sarcafac.animation_paused.connect(_animation, CONNECT_DEFERRED)


func _animation() -> void:
	sarcafac.hide()
	show()
	var t: Tween = create_tween().chain()
	t.tween_method(_set_progress, 1.0, -0.5, 2)
	await t.finished
	sarcafac.animation_continue.emit()


func _set_progress(v: float) -> void:
	set_instance_shader_parameter(&"progress", v)
