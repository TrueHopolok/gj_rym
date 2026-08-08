class_name PresesurePlate
extends Node2D

@onready var area_2d: Area2D = %Area2D
@export var target: PowerComponent = null
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _physics_process(_delta: float) -> void:
	if is_instance_valid(target):
		var pressed: bool = area_2d.has_overlapping_areas() or area_2d.has_overlapping_bodies()
		var anim: StringName = &"pressed" if pressed else &"idle"
		animation_player.play(anim, 0.5)
		target.set_powered(pressed)
