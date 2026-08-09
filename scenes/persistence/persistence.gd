extends Node

const SAVE_PATH: String = "user://progression.bin"

var unlocked_level: int = 1
var current_level: int = 1


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
	file.close()


## Saves unlocked level from memory to file
func _save() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("[Persistence]: saving error:", FileAccess.get_open_error())
		return
	# NOTE: file.store_string(JSON.stringify(data))
	if not file.store_32(unlocked_level):
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
	submit()
