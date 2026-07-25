extends Control

# settings
var n_reps_slow = 10
var n_reps_fast = 10
var t_reps_slow = 5.0
var t_reps_fast = 1.0

# variables
var size_rest
var size_squeeze

func _ready() -> void:
	var button_y = %ButtonMargin.custom_minimum_size.y
	size_rest = Vector2(button_y, button_y)
	size_squeeze = Vector2(button_y, button_y) / 1.5

func _process(_delta: float) -> void:
	if not $Timer.is_stopped():
		var t_reps = 1
		if %Speed.text == "Slow":
			t_reps = t_reps_slow
		elif %Speed.text == "Fast":
			t_reps = t_reps_fast
		%StartButton.text = str(int($Timer.time_left) % int(t_reps) + 1)

func _on_start_button_pressed() -> void:
	%StartButton.disabled = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	$Timer.wait_time = n_reps_slow * t_reps_slow
	$Timer.start()
	for i in n_reps_slow:
		kegel_animation(tween, "Slow", i, n_reps_slow, t_reps_slow)
	for i in n_reps_fast:
		kegel_animation(tween, "Fast", i, n_reps_fast, t_reps_fast)
	await tween.finished
	%Instruction.text = ""
	%Speed.text = ""
	%Counter.text = ""
	$Timer.stop()
	%StartButton.text = "Start"
	%StartButton.disabled = false

func kegel_animation(tween, speed, count, n_reps, time):
	var left = n_reps - count
	var plural = "s" if left > 1 else ""
	var count_text = "%d rep%s more to go" % [left, plural]
	tween.tween_callback(%Instruction.set_text.bind("Squeeze"))
	tween.tween_callback(%Speed.set_text.bind(speed))
	tween.tween_callback(%Counter.set_text.bind(count_text))
	tween.tween_property(%CurtainClear, "size_flags_stretch_ratio", 0, time)
	tween.parallel()
	tween.tween_property(%CurtainWhite, "size_flags_stretch_ratio", 1, time)
	tween.parallel()
	tween.tween_property(%StartButton, "custom_minimum_size", size_squeeze, 1)
	tween.tween_callback(%Instruction.set_text.bind("Rest"))
	tween.tween_property(%CurtainClear, "size_flags_stretch_ratio", 1, time)
	tween.parallel()
	tween.tween_property(%CurtainWhite, "size_flags_stretch_ratio", 0, time)
	tween.parallel()
	tween.tween_property(%StartButton, "custom_minimum_size", size_rest, 1)
