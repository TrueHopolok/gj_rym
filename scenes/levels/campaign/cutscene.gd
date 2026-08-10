extends AnimationPlayer


func wake_player() -> void:
	get_tree().call_group(&"player", "set_state", Player.PlayerStates.IDLE)
