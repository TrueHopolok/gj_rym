class_name CorpseSpiked
extends StaticBody2D

const SCENE: PackedScene = preload("res://scenes/corpse/corpse_spiked.tscn")


static func spawn(parent: Node, spike_normal: Vector2, spike_pos: Vector2) -> CorpseSpiked:
	var inst: Node2D = SCENE.instantiate()
	parent.add_child(inst)
	inst.global_position = spike_pos
	inst.global_rotation = spike_normal.angle()

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
