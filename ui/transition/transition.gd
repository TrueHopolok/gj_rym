extends CanvasLayer

const DURATION: float = 0.5


func fade_in() -> void:
	var bg: ColorRect = $ColorRect
	bg.show()
	var tween: Tween = create_tween()
	tween.tween_property(bg, "color", Color(0, 0, 0, 1), DURATION)
	await tween.finished


func fade_out() -> void:
	var bg: ColorRect = $ColorRect
	var tween: Tween = create_tween()
	tween.tween_property(bg, "color", Color(0, 0, 0, 0), DURATION)
	await tween.finished
	bg.hide()


## Changes to scene by given path.
func change_scene_path(path: String, stop_global_music: bool = false) -> void:
	await fade_in()
	if stop_global_music:
		(GlobalMusic as AudioStreamPlayer).stop()
	else:
		(GlobalMusic as StrongerAudioPlayer).try_to_play()
	get_tree().change_scene_to_file(path)
	get_tree().paused = false
	await fade_out()


## Reloads current scene.
func reload_scene() -> void:
	await fade_in()
	get_tree().reload_current_scene()
	get_tree().paused = false
	await fade_out()
