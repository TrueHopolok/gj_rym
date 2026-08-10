extends AudioStreamPlayer

@export var _loop: AudioStream


func _ready() -> void:
	finished.connect(
		func() -> void:
			stream = _loop
			play()
	)
