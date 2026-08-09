class_name BetterButton
extends Button

# use load("sfx") to set some sfx as default
@export var _press_sfx: AudioStream = load("res://assets/audio/sfx/ui_button.mp3")
@export var _volume_db: int = -36


func _ready() -> void:
	_set_sfx()
	pressed.connect(_on_press)


## Overridable method that is called on each button press
func _on_press() -> void:
	pass


func _set_sfx() -> void:
	var press_sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	press_sfx_player.volume_db = _volume_db
	press_sfx_player.stream = _press_sfx
	pressed.connect(press_sfx_player.play)
	add_child(press_sfx_player)
