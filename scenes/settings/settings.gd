extends Control

func _ready() -> void:
	%NRepsSlow.value = Globals.n_reps_slow
	%NRepsFast.value = Globals.n_reps_fast
	%TRepsSlow.value = Globals.t_reps_slow
	%TRepsFast.value = Globals.t_reps_fast
	%SpeakerOption.button_pressed = Globals.speaker
	%VibrateOption.button_pressed = Globals.vibrate
	%NRepsSlow.changed.connect(func(x):Globals.n_reps_slow=x)
	%NRepsFast.changed.connect(func(x):Globals.n_reps_fast=x)
	%TRepsSlow.changed.connect(func(x):Globals.t_reps_slow=x)
	%TRepsFast.changed.connect(func(x):Globals.t_reps_fast=x)

func _on_speaker_option_toggled(toggled_on: bool) -> void:
	Globals.speaker = toggled_on

func _on_vibrate_option_toggled(toggled_on: bool) -> void:
	Globals.vibrate = toggled_on
