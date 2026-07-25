extends Control

# settings
var n_reps_slow = 10
var n_reps_fast = 10
var t_reps_slow = 5.0
var t_reps_fast = 1.0

func _on_start_button_pressed() -> void:
	%StartButton.disabled = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	for i in n_reps_slow:
		kegel_animation(tween, "Slow", i, n_reps_slow, t_reps_slow)
	for i in n_reps_fast:
		kegel_animation(tween, "Fast", i, n_reps_fast, t_reps_fast)
	await tween.finished
	%Instruction.text = ""
	%Speed.text = ""
	%Counter.text = ""
	%StartButton.disabled = false

func kegel_animation(tween, speed, count, n_reps, time):
	var count_text = "%d reps more to go" % (n_reps - count)
	tween.tween_callback(%Instruction.set_text.bind("Squeeze")).set_delay(0)
	tween.tween_callback(%Speed.set_text.bind(speed)).set_delay(0)
	tween.tween_callback(%Counter.set_text.bind(count_text)).set_delay(0)
	tween.tween_property($RectEffect, "size:y", 1280, time)
	tween.parallel().tween_property($RectEffect, "position:y", 0, time)
	tween.tween_callback(%Instruction.set_text.bind("Rest")).set_delay(0)
	tween.tween_property($RectEffect, "size:y", 0, time)
	tween.parallel().tween_property($RectEffect, "position:y", 1280, time)
