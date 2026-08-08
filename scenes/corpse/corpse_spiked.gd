class_name CorpseSpiked
extends StaticBody2D

const SCENE: PackedScene = preload("res://scenes/corpse/corpse_spiked.tscn")

@onready var sprite: Sprite2D = $Sprite2D


static func spawn(parent: Node, spike_normal: Vector2, spike_pos: Vector2) -> CorpseSpiked:
	var should_flip: bool = spike_normal.x < 0 or (is_zero_approx(spike_normal.x) and randi() % 2 == 0)
	if should_flip:
		spike_normal = -spike_normal

	var inst: CorpseSpiked = SCENE.instantiate()
	parent.add_child(inst)
	inst.global_position = spike_pos
	inst.global_rotation = spike_normal.angle()
	inst.sprite.flip_v = should_flip

	return inst


static func is_spike_collision(col: KinematicCollision2D) -> bool:
	if col.get_collider() is TileMapLayer:
		var tm: TileMapLayer = col.get_collider() as TileMapLayer
		var pos: Vector2i = tm.local_to_map(tm.to_local(col.get_position() - col.get_normal()))
		var td: TileData = tm.get_cell_tile_data(pos)
		return td != null and td.get_custom_data("is_spike")
	elif col.get_collider() is Node:
		var node: Node = col.get_collider()
		return node.is_in_group(&"spike")

	return false
