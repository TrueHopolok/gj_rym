extends BetterButton

const CAMPAIGN_PATH: String = "res://scenes/levels/campaign/campaign%d.tscn"

@onready var _lvl_num: int = clampi(Persistence.unlocked_level, 1, 10)


func _ready() -> void:
	super()
	disabled = _lvl_num <= 1


func _on_press() -> void:
	Persistence.current_level = _lvl_num
	Transition.change_scene_path(CAMPAIGN_PATH % _lvl_num)
