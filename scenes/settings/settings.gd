extends Control

signal speaker_option_toggled
signal vibrate_option_toggled

func _ready() -> void:
	%NRepsSlow.value = Globals.n_reps_slow
	%NRepsFast.value = Globals.n_reps_fast
	%TRepsSlow.value = Globals.t_reps_slow
	%TRepsFast.value = Globals.t_reps_fast
	%NRepsSlow.changed.connect(func(x):Globals.n_reps_slow=x)
	%NRepsFast.changed.connect(func(x):Globals.n_reps_fast=x)
	%TRepsSlow.changed.connect(func(x):Globals.t_reps_slow=x)
	%TRepsFast.changed.connect(func(x):Globals.t_reps_fast=x)

func _on_speaker_option_toggled(toggled_on: bool) -> void:
	speaker_option_toggled.emit(toggled_on)

func _on_vibrate_option_toggled(toggled_on: bool) -> void:
	vibrate_option_toggled.emit(toggled_on)
