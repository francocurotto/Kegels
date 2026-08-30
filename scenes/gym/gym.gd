extends Control

# signals
signal train_started
signal train_ended

# variables
var tween
var size_rest
var size_squeeze
var curtain_clear
var curtain_white
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
	tween.tween_callback(on_start_slow_kegels)
	for i in Globals.n_reps_slow:
		kegel_animation(i, Globals.n_reps_slow, Globals.t_slow_squeeze, Globals.t_slow_rest)
	tween.tween_callback(on_start_fast_kegels)
	for i in Globals.n_reps_fast:
		kegel_animation(i, Globals.n_reps_fast, Globals.t_fast_squeeze, Globals.t_fast_rest)
	tween.tween_callback(on_kegels_finished)

func on_start_slow_kegels():
	%Speed.text = "Slow"
	%OptionsRow.visible = true
	t_squeeze = Globals.t_slow_squeeze
	t_rest = Globals.t_slow_rest

func on_start_fast_kegels():
	%Speed.text = "Fast"
	t_squeeze = Globals.t_fast_squeeze
	t_rest = Globals.t_fast_rest

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
