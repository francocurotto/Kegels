# Gym script. Handles the Kegels exercises excecution.
extends Control

#region signals
signal train_started
signal train_ended
#endregion

#region public variables
var curtain_clear ## Reference to color rect for curtain animation. Clear part.
var curtain_white ## Refernece to color rect for curtain animation. White part.
#endregion

#region private variables
var tween ## Tween for the kegel exercises animations.
var button_size_rest ## Start button size when in rest part of kegel.
var button_size_squeeze ## Start button size whem in squeeze part of kegel.
#endregion

#region onready variables
@onready var play_icon = preload("res://assets/icons/play.svg")
@onready var pause_icon = preload("res://assets/icons/pause.svg")
@onready var speaker_off_icon = preload("res://assets/icons/speaker-off.svg")
@onready var speaker_on_icon = preload("res://assets/icons/speaker-on.svg")
@onready var vibrate_off_icon = preload("res://assets/icons/vibrate-off.svg")
@onready var vibrate_on_icon = preload("res://assets/icons/vibrate-on.svg")
#endregion

#region builtin functions
func _ready() -> void:
	button_size_rest = %StartButton.size
	button_size_squeeze = %StartButton.size / 1.5
	%OptionsRow.visible = false

func _process(_delta: float) -> void:
	if not $Timer.is_stopped():
		var kegel_time = min($Timer.wait_time, $Timer.time_left+1)
		%StartButton.text = str(int(kegel_time))
#endregion

#region signals callbacks
func _on_start_button_pressed() -> void:
	train_started.emit()
	%StartButton.disabled = true
	%OptionsRow.visible = true
	%SpeakerButton.button_pressed = Globals.speaker
	%VibrateButton.button_pressed = Globals.vibrate
	create_animation()

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
#endregion

#region private functions
## Create the full kegel animation by tweening the timer, the curtain, 
## the button and the text.
func create_animation():
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Globals.animation)
	var params = define_kegel_order()
	tween.tween_callback(on_start_kegels.bind(params[0]))
	for i in params[0]["n_reps"]:
		kegel_animation(i, params[0])
	tween.tween_callback(on_start_kegels.bind(params[1]))
	for i in params[1]["n_reps"]:
		kegel_animation(i, params[1])
	tween.tween_callback(on_kegels_finished)

## Set the parameters in the correct order given the order setting.
func define_kegel_order():
	var params_slow = {
		"n_reps" : Globals.n_reps_slow,
		"t_squeeze" : Globals.t_slow_squeeze,
		"t_rest" : Globals.t_slow_rest,
		"speed_text" : "Slow", 
	}
	var params_fast = {
		"n_reps" : Globals.n_reps_fast,
		"t_squeeze" : Globals.t_fast_squeeze,
		"t_rest" : Globals.t_fast_rest,
		"speed_text" : "Fast", 
	}
	if Globals.order == 0:
		return [params_slow, params_fast]
	elif Globals.order == 1:
		return [params_slow, params_fast]

func on_start_kegels(params):
	%Speed.text = params["speed_text"]

func kegel_animation(count, params):
	var n_reps = params["n_reps"]
	var t_squeeze = params["t_squeeze"]
	var t_rest  = params["t_rest"]
	tween.tween_callback(on_kegel_squeeze.bind(count, n_reps, t_squeeze))
	tween.tween_property(curtain_clear, "size_flags_stretch_ratio", 0, t_squeeze)
	tween.parallel()
	tween.tween_property(curtain_white, "size_flags_stretch_ratio", 1, t_squeeze)
	tween.parallel()
	tween.tween_property(%StartButton, "custom_minimum_size", button_size_squeeze, 1)
	tween.tween_callback(on_kegel_rest.bind(t_rest))
	tween.tween_property(curtain_clear, "size_flags_stretch_ratio", 1, t_rest)
	tween.parallel()
	tween.tween_property(curtain_white, "size_flags_stretch_ratio", 0, t_rest)
	tween.parallel()
	tween.tween_property(%StartButton, "custom_minimum_size", button_size_rest, 1)

func on_kegel_squeeze(count, n_reps, t_squeeze):
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

func on_kegel_rest(t_rest):
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
	Globals.stats[Time.get_date_string_from_system()] += 1
	train_ended.emit()
#endregion
