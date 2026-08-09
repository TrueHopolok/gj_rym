@tool
class_name Altar
extends Node2D

@export var _player: PackedScene
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(is_instance_valid(_player), "WTH man, who do I spawn")
	spawn()


func spawn() -> void:
	_animation_player.play(&"revive")

	await get_tree().create_timer(0.5).timeout
	var inst: Player = _player.instantiate() as Player
	inst.global_position = global_position
	inst.global_position.y -= 16  # yes, magic constant, but idc
	inst.died.connect(spawn, CONNECT_ONE_SHOT)
	get_parent().add_child.call_deferred(inst)


func emit_particles() -> void:
	for child: Node in get_children():
		var p: CPUParticles2D = child as CPUParticles2D
		if is_instance_valid(p):
			p.emitting = true
