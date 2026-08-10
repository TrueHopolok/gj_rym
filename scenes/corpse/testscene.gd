extends Node2D

@onready var corpse: Corpse = %Corpse


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		corpse.apply_impulse(Vector2(-300, -400))
	if Input.is_action_just_pressed("ui_right"):
		corpse.apply_impulse(Vector2(300, -400))
