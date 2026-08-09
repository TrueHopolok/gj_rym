class_name StrongerAudioPlayer
extends AudioStreamPlayer


@export var _intro: AudioStream
@export var _loop: AudioStream


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