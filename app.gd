extends Control

func _on_start_button_pressed() -> void:
	%StartButton.disabled = true
	var tween = create_tween()
	tween.tween_property($RectEffect, "size:y", 1280, 5.0)
	tween.parallel().tween_property($RectEffect, "position:y", 0, 5.0)
	tween.tween_property($RectEffect, "size:y", 0, 5.0)
	tween.parallel().tween_property($RectEffect, "position:y", 1280, 5.0)
	await tween.finished
	%StartButton.disabled = false
