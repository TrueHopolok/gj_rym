extends BetterButton


const CAMPAIGN_PATH: String = "res://scenes/levels/campaign/campaign%d.tscn"

@export_range(1, 10, 1) var _lvl_num: int = 1


func _ready() -> void:
	super()
	print(Persistence.unlocked_level)
	disabled = _lvl_num > Persistence.unlocked_level


func _on_press() -> void:
	print("YOOO")
	Persistence.current_level = _lvl_num
	Transition.change_scene_path(CAMPAIGN_PATH % _lvl_num)
