class_name StrongerAudioPlayer
extends AudioStreamPlayer

@export var _intro: AudioStream
@export var _loop: AudioStream

var _hk_current_stage: int = 1

@onready var _hk_idx: int = AudioServer.get_bus_index("Music_HK")
@onready var _regular_idx: int = AudioServer.get_bus_index("Music_regular")


func _ready() -> void:
	finished.connect(
		func() -> void:
			stream = _loop
			play()
	)


func try_to_play() -> void:
	if playing:
		return
	stream = _intro
	play()


func set_stage(stage: int) -> void:
	if stage == 2 && _hk_current_stage == 3:
		return
	if stage == 2 && _hk_current_stage == 2:
		stage = 3
	var cur: AudioStreamPlayer = get_child(_hk_current_stage - 1) as AudioStreamPlayer
	var next: AudioStreamPlayer = get_child(stage - 1) as AudioStreamPlayer
	cur.volume_db = -80
	next.volume_db = 0
	_hk_current_stage = stage


func hk_toggle() -> void:
	AudioServer.set_bus_mute(_hk_idx, !AudioServer.is_bus_mute(_hk_idx))
	AudioServer.set_bus_mute(_regular_idx, !AudioServer.is_bus_mute(_hk_idx))
