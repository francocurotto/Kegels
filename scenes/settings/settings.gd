extends Control

func _ready() -> void:
	%NRepsSlow.value = Globals.n_reps_slow
	%NRepsFast.value = Globals.n_reps_fast
	%TSlowSqueeze.value = Globals.t_slow_squeeze
	%TSlowRest.value = Globals.t_slow_rest
	%TFastSqueeze.value = Globals.t_fast_squeeze
	%TFastRest.value = Globals.t_fast_rest
	%SpeakerOption.button_pressed = Globals.speaker
	%VibrateOption.button_pressed = Globals.vibrate
	%NRepsSlow.changed.connect(func(x):Globals.n_reps_slow=x)
	%NRepsFast.changed.connect(func(x):Globals.n_reps_fast=x)
	%TSlowSqueeze.changed.connect(func(x):Globals.t_slow_squeeze=x)
	%TSlowRest.changed.connect(func(x):Globals.t_slow_rest=x)
	%TFastSqueeze.changed.connect(func(x):Globals.t_fast_squeeze=x)
	%TFastRest.changed.connect(func(x):Globals.t_fast_rest=x)

func _on_speaker_option_toggled(toggled_on: bool) -> void:
	Globals.speaker = toggled_on

func _on_vibrate_option_toggled(toggled_on: bool) -> void:
	Globals.vibrate = toggled_on
