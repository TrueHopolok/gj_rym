class_name CorpseSpiked
extends StaticBody2D

## Types of spikes. Must correspond to tilemap custom data &"spike_type"
enum SpikeType {
	NONE,
	NORMAL,
	CURSED,
}

const SCENE: PackedScene = preload("res://scenes/corpse/corpse_spiked.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var _sfx_death: AudioStreamPlayer = $SFXDeath


func _ready() -> void:
	_sfx_death.play()


static func spawn(parent: Node, spike_normal: Vector2, spike_pos: Vector2) -> CorpseSpiked:
	var should_flip: bool = (
		spike_normal.x < 0 or (is_zero_approx(spike_normal.x) and randi() % 2 == 0)
	)
	if should_flip:
		spike_normal = -spike_normal

	var inst: CorpseSpiked = SCENE.instantiate()
	(
		(func() -> void:
			parent.add_child(inst)
			inst.global_position = spike_pos
			inst.global_rotation = spike_normal.angle()
			inst.sprite.flip_v = should_flip)
		. call_deferred()
	)

	return inst


static func get_spike_collision_type(collider: Object, posi: Vector2, normal: Vector2) -> SpikeType:
	const SPIKE_LAYER_MASK: int = 1 << 3

	if collider is TileMapLayer:
		var tm: TileMapLayer = collider as TileMapLayer

		var params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		params.position = posi - normal
		params.collide_with_areas = true
		params.collide_with_bodies = true
		params.collision_mask = SPIKE_LAYER_MASK

		if tm.get_world_2d().direct_space_state.intersect_point(params, 1).is_empty():
			return SpikeType.NONE

		var pos: Vector2i = tm.local_to_map(tm.to_local(posi - normal))
		var td: TileData = tm.get_cell_tile_data(pos)
		if td == null:
			return SpikeType.NONE
		var t: Variant = td.get_custom_data("spike_type")
		if t is not int:
			return SpikeType.NONE

		return t

	return SpikeType.NONE
