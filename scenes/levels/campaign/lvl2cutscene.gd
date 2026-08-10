extends Node2D


func _ready() -> void:
	setup.call_deferred()


func setup() -> void:
	var a: Altar = get_tree().get_first_node_in_group(&"altar") as Altar
	var c: CustomCamera = get_tree().get_first_node_in_group(&"custom_camera") as CustomCamera

	var p: Player = await a.player_spawned
	a.disown(p)
	await p.died

	c.take_control()

	var pos: Vector2 = p.global_position

	var l: RichTextLabel = %CutsceneLabel

	var label_size: Vector2 = l.get_global_rect().size
	l.global_position = pos + Vector2.UP * 48 + Vector2.LEFT * label_size.x * 0.5
	l.visible_ratio = 0

	a.spawn_player_state = Player.PlayerStates.BUSY

	# I heard you liked magic numbers?
	var t: Tween = create_tween()
	t.tween_property(c, "global_position", pos, 1.0)
	t.parallel().tween_property(c, "zoom", Vector2(2.7, 2.7), 1.0)
	t.chain().tween_interval(1.0)
	t.chain().tween_property(l, "visible_ratio", 0.38, 2.0).from(0.0)
	t.chain().tween_interval(1.0)
	t.chain().tween_property(l, "visible_ratio", 1, 2.0)
	t.chain().tween_interval(1.0)
	t.chain().tween_property(c, "global_position", a.global_position + Vector2.UP * 24, 1.0)
	t.parallel().tween_property(c, "zoom", Vector2(1.7, 1.7), 1.0)
	t.parallel().tween_property(l, "modulate:a", 0.0, 1)
	t.chain().tween_callback(a.spawn)
	t.chain().tween_interval(1)

	await t.finished

	get_tree().call_group(&"player", "set_state", Player.PlayerStates.IDLE)
	a.spawn_player_state = Player.PlayerStates.IDLE
	c.release_control()
