class_name Altar
extends Node2D


@export var _player: PackedScene


func _ready() -> void:
	assert(is_instance_valid(_player), "WTH man, who do I spawn")
	spawn()


func spawn() -> void:
	var inst: Player = _player.instantiate() as Player
	inst.global_position = global_position
	inst.died.connect(spawn, CONNECT_ONE_SHOT)
	get_parent().add_child.call_deferred(inst)