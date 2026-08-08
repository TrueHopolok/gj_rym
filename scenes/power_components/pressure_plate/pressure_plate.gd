@tool
class_name PresesurePlate
extends Node2D

@export var target: PowerComponent = null
@export var symbol: PowerComponent.Symbol = PowerComponent.Symbol.IOI_GATE:
	set(v):
		symbol = v
		if is_inside_tree():
			_update_symbol.call_deferred()

var _was_pressed: bool = false

@onready var _area_2d: Area2D = %Area2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _symbol_sprite: Sprite2D = %Symbol



func _ready() -> void:
	_update_symbol.call_deferred()


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target) or Engine.is_editor_hint():
		return

	var pressed: bool = _area_2d.has_overlapping_areas() or _area_2d.has_overlapping_bodies()

	if _was_pressed != pressed:
		var anim: StringName = &"down" if pressed else &"up"
		_animation_player.play(anim)

	_was_pressed = pressed
	target.set_powered(pressed)


func _update_symbol() -> void:
	if not _symbol_sprite.is_node_ready():
		await _symbol_sprite.ready
	_symbol_sprite.frame = int(symbol)
