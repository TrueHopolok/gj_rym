extends Node

const SAVE_PATH: String = "user://progression.bin"

var unlocked_level: int = 1
var current_level: int = 1
var pain_left: bool = false
var pain_right: bool = false


func _init() -> void:
	_load()


## Loads unlocked level or set to default
func _load() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		var err: Error = FileAccess.get_open_error()
		if err != ERR_FILE_NOT_FOUND:
			printerr("[Persistence]: loading error:", FileAccess.get_open_error())
		return
	# NOTE: data = JSON.parse_string(file.get_as_text())
	unlocked_level = file.get_32()
	pain_left = file.get_8()
	pain_right = file.get_8()
	file.close()


## Saves unlocked level from memory to file
func _save() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("[Persistence]: saving error:", FileAccess.get_open_error())
		return
	# NOTE: file.store_string(JSON.stringify(data))
	if (
		not file.store_32(unlocked_level)
		|| not file.store_8(pain_left)
		|| not file.store_8(pain_right)
	):
		push_error("[Persistence]: saving error:", FileAccess.get_open_error())
	file.close()


## Updates unlocked level if it was beaten and saves into file if it was
func submit() -> void:
	if current_level <= unlocked_level:
		return
	unlocked_level = current_level
	_save()


## Resets unlocked level back to 1 both in memory and in file
func reset() -> void:
	unlocked_level = 0
	current_level = 1
	pain_left = false
	pain_right = false
	submit()
