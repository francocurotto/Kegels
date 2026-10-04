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
var states
var state_count
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
		%StartButton.text = str(int(ceil($Timer.time_left)))
		var current_state = states[state_count]
		var ratio = $Timer.time_left / $Timer.wait_time
		if current_state.type == "Squeeze":
			curtain_clear.size_flags_stretch_ratio = ratio
			curtain_white.size_flags_stretch_ratio = 1 - ratio
		elif current_state.type == "Rest":
			curtain_clear.size_flags_stretch_ratio = 1 - ratio
			curtain_white.size_flags_stretch_ratio = ratio
#endregion

#region signals callbacks
func _on_start_button_pressed() -> void:
	train_started.emit()
	%StartButton.disabled = true
	%OptionsRow.visible = true
	%SpeakerButton.button_pressed = Globals.speaker
	%VibrateButton.button_pressed = Globals.vibrate
	state_count = 0
	create_kegel_states()
	update_kegel_state()

func _on_timer_timeout() -> void:
	state_count += 1
	if state_count < len(states):
		update_kegel_state()
	else:
		finish_kegel()

func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%PauseButton.icon = play_icon
		$Timer.paused = true
	else:
		%PauseButton.icon = pause_icon
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
## Create the array of states for the kegel exercises given by the user
## settings.
func create_kegel_states():
	var slow_states = []
	var fast_states = []
	for i in Globals.n_reps_slow:
		slow_states += create_slow_kegel_states(Globals.n_reps_slow - i)
	for i in Globals.n_reps_fast:
		fast_states += create_fast_kegel_states(Globals.n_reps_fast - i)
	if Globals.order == 0:
		states = slow_states + fast_states
	elif Globals.order == 1:
		states = fast_states + slow_states

## Create the array of kegel states for the slow kegels.
func create_slow_kegel_states(index):
	var state_slow_squeeze = KegelState.new()
	state_slow_squeeze.type = "Squeeze"
	state_slow_squeeze.speed = "Slow"
	state_slow_squeeze.index = index
	state_slow_squeeze.time = Globals.t_slow_squeeze
	var state_slow_rest = KegelState.new()
	state_slow_rest.type = "Rest"
	state_slow_rest.speed = "Slow"
	state_slow_rest.index = index
	state_slow_rest.time = Globals.t_slow_rest
	return [state_slow_squeeze, state_slow_rest]

## Create the array of kegel states for the fast kegels.
func create_fast_kegel_states(index):
	var state_fast_squeeze = KegelState.new()
	state_fast_squeeze.type = "Squeeze"
	state_fast_squeeze.speed = "Fast"
	state_fast_squeeze.index = index
	state_fast_squeeze.time = Globals.t_fast_squeeze
	var state_fast_rest = KegelState.new()
	state_fast_rest.type = "Rest"
	state_fast_rest.speed = "Fast"
	state_fast_rest.index = index
	state_fast_rest.time = Globals.t_fast_rest
	return [state_fast_squeeze, state_fast_rest]

## Update the texts, play the sfx, and the timer on each kegel state 
## transition, given the new state.
func update_kegel_state():
	# get the current state
	var current_state = states[state_count]
	# set the type (squeeze, rest) text
	%Instruction.text = current_state.type
	# set the speed text
	%Speed.text = current_state.speed
	# set the counter text
	var plural = "s" if current_state.index > 1 else ""
	%Counter.text = "%d rep%s more to go" % [current_state.index, plural]
	# activate the enabled feedback
	if %SpeakerButton.button_pressed:
		if current_state.type == "Squeeze":
			$AudioSqueeze.play()
		elif current_state.type == "Rest":
			$AudioRest.play()
	if %VibrateButton.button_pressed:
		Input.vibrate_handheld()
	# start button tween
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	if current_state.type == "Squeeze":
		tween.tween_property(%StartButton, "custom_minimum_size", button_size_squeeze, 1)
	elif current_state.type == "Rest":
		tween.tween_property(%StartButton, "custom_minimum_size", button_size_rest, 1)
	# update the timer and start
	$Timer.wait_time = current_state.time
	$Timer.start()

## Reset the texts, curtain and buttons after the end of the kegel exercise.
func finish_kegel():
	%Instruction.text = ""
	%Speed.text = ""
	%Counter.text = ""
	curtain_clear.size_flags_stretch_ratio = 1
	curtain_white.size_flags_stretch_ratio = 0
	$Timer.stop()
	%StartButton.text = "Start"
	%OptionsRow.visible = false
	%StartButton.disabled = false
	Globals.stats[Time.get_date_string_from_system()] += 1
	train_ended.emit()
#endregion

#region inner classes
## State of the kegel exercise, in terms of squeeze/rest, speed, and count.
class KegelState:
	var type : String
	var speed : String
	var index : int
	var time : float
#endregion
