extends Control

# settings
var n_reps_slow = 10
var n_reps_fast = 10
var t_reps_slow = 5.0
var t_reps_fast = 1.0

# variables
	

func _on_start_button_pressed() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	%StartButton.disabled = true
	for i in n_reps_slow:
		kegel_animation(tween, "Slow", n_reps_slow-i, t_reps_slow)
	for i in n_reps_fast:
		kegel_animation(tween, "Fast", n_reps_fast-i, t_reps_fast)
	await tween.finished
	%StartButton.disabled = false

func kegel_animation(tween, speed, count, time):
	%InstructionText.text = "Squeeze"
	%SpeedText.text = speed
	%CounterText.text = "%d reps more to go" % count
	tween.tween_property($RectEffect, "size:y", 1280, time)
	tween.parallel().tween_property($RectEffect, "position:y", 0, time)
	%InstructionText.text = "Rest"
	tween.tween_property($RectEffect, "size:y", 0, time)
	tween.parallel().tween_property($RectEffect, "position:y", 1280, time)
