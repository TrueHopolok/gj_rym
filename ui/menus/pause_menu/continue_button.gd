extends BetterButton


func _ready() -> void:
	super()
	visibility_changed.connect(_on_visibility_changed)


func _on_press() -> void:
	get_tree().paused = false


func _on_visibility_changed() -> void:
	if visible:
		grab_focus()
