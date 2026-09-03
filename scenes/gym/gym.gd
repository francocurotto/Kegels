extends Control

# signals
signal train_started
signal train_ended

# variables
var tween
# button animation variables
var size_rest
var size_squeeze
# curtain animation variables
var curtain_clear
var curtain_white
# order control variables
var n_reps_1
var t_squeeze_1
var t_rest_1
var speed_text_1
var n_reps_2
var t_squeeze_2
var t_rest_2
var speed_text_2
#
var t_squeeze
var t_rest

# onready variables
@onready var play_icon = preload("res://assets/icons/play.svg")
@onready var pause_icon = preload("res://assets/icons/pause.svg")
@onready var speaker_off_icon = preload("res://assets/icons/speaker-off.svg")
@onready var speaker_on_icon = preload("res://assets/icons/speaker-on.svg")
@onready var vibrate_off_icon = preload("res://assets/icons/vibrate-off.svg")
@onready var vibrate_on_icon = preload("res://assets/icons/vibrate-on.svg")

func _ready() -> void:
	var button_y = %ButtonMargin.custom_minimum_size.y
	size_rest = Vector2(button_y, button_y)
	size_squeeze = Vector2(button_y, button_y) / 1.5
	%OptionsRow.visible = false

func _process(_delta: float) -> void:
	if not $Timer.is_stopped():
		%StartButton.text = str(int(min($Timer.wait_time, $Timer.time_left+1)))

func _on_start_button_pressed() -> void:
	train_started.emit()
	%StartButton.disabled = true
	%SpeakerButton.button_pressed = Globals.speaker
	%VibrateButton.button_pressed = Globals.vibrate
	prepare_animation()
	create_animation()

func prepare_animation():
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

func create_animation():
	define_kegel_order()
	%OptionsRow.visible = true
	tween.tween_callback(on_start_kegels_1)
	for i in n_reps_1:
		kegel_animation(i, n_reps_1, t_squeeze_1, t_rest_1)
	tween.tween_callback(on_start_kegels_2)
	for i in n_reps_2:
		kegel_animation(i, n_reps_2, t_squeeze_2, t_rest_2)
	tween.tween_callback(on_kegels_finished)

func on_start_kegels_1():
	%Speed.text = speed_text_1
	t_squeeze = t_squeeze_1
	t_rest = t_rest_1

func on_start_kegels_2():
	%Speed.text = speed_text_2
	t_squeeze = t_squeeze_2
	t_rest = t_rest_2

func define_kegel_order():
	if Globals.order == 0:
		n_reps_1 = Globals.n_reps_slow
		t_squeeze_1 = Globals.t_slow_squeeze
		t_rest_1 = Globals.t_slow_rest
		speed_text_1 = "Slow"
		n_reps_2 = Globals.n_reps_fast
		t_squeeze_2 = Globals.t_fast_squeeze
		t_rest_2 = Globals.t_fast_rest
		speed_text_2 = "Fast"
	elif Globals.order == 1:
		n_reps_1 = Globals.n_reps_fast
		t_squeeze_1 = Globals.t_fast_squeeze
		t_rest_1 = Globals.t_fast_rest
		speed_text_1 = "Fast"
		n_reps_2 = Globals.n_reps_slow
		t_squeeze_2 = Globals.t_slow_squeeze
		t_rest_2 = Globals.t_slow_rest
		speed_text_2 = "Slow"

func kegel_animation(count, n_reps, time_squeeze, time_rest):
	tween.tween_callback(on_kegel_squeeze.bind(n_reps, count))
	tween.tween_property(curtain_clear, "size_flags_stretch_ratio", 0, time_squeeze)
	tween.parallel()
	tween.tween_property(curtain_white, "size_flags_stretch_ratio", 1, time_squeeze)
	tween.parallel()
	tween.tween_property(%StartButton, "custom_minimum_size", size_squeeze, 1)
	tween.tween_callback(on_kegel_rest)
	tween.tween_property(curtain_clear, "size_flags_stretch_ratio", 1, time_rest)
	tween.parallel()
	tween.tween_property(curtain_white, "size_flags_stretch_ratio", 0, time_rest)
	tween.parallel()
	tween.tween_property(%StartButton, "custom_minimum_size", size_rest, 1)

func on_kegel_squeeze(n_reps, count):
	$Timer.wait_time = t_squeeze
	$Timer.start()
	var left = n_reps - count
	var plural = "s" if left > 1 else ""
	%Counter.text = "%d rep%s more to go" % [left, plural]
	%Instruction.text = "Squeeze"
	if %SpeakerButton.button_pressed:
		$AudioSqueeze.play()
	if %VibrateButton.button_pressed:
		Input.vibrate_handheld()

func on_kegel_rest():
	$Timer.wait_time = t_rest
	$Timer.start()
	%Instruction.text = "Rest"
	if %SpeakerButton.button_pressed:
		$AudioRest.play()
	if %VibrateButton.button_pressed:
		Input.vibrate_handheld()

func on_kegels_finished():
	%Instruction.text = ""
	%Speed.text = ""
	%Counter.text = ""
	$Timer.stop()
	%StartButton.text = "Start"
	%OptionsRow.visible = false
	%StartButton.disabled = false
	train_ended.emit()

func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%PauseButton.icon = play_icon
		tween.pause()
		$Timer.paused = true
	else:
		%PauseButton.icon = pause_icon
		tween.play()
		$Timer.paused = false

func _on_speaker_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%SpeakerButton.icon = speaker_on_icon
	else:
		%SpeakerButton.icon = speaker_off_icon

func _on_vibrate_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%VibrateButton.icon = vibrate_on_icon
	else:
		%VibrateButton.icon = vibrate_off_icon
