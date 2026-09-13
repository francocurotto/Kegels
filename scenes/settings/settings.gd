extends Control

signal goal_changed

func _ready() -> void:
	%NRepsSlow.value = Globals.n_reps_slow
	%NRepsFast.value = Globals.n_reps_fast
	%TSlowSqueeze.value = Globals.t_slow_squeeze
	%TSlowRest.value = Globals.t_slow_rest
	%TFastSqueeze.value = Globals.t_fast_squeeze
	%TFastRest.value = Globals.t_fast_rest
	%OrderButton.selected = Globals.order
	%Goal.value = Globals.goal
	%SpeakerOption.button_pressed = Globals.speaker
	%VibrateOption.button_pressed = Globals.vibrate
	%NRepsSlow.changed.connect(on_n_reps_slow_changed)
	%NRepsFast.changed.connect(on_n_reps_fast_changed)
	%TSlowSqueeze.changed.connect(on_t_slow_squeeze_changed)
	%TSlowRest.changed.connect(on_t_slow_rest_changed)
	%TFastSqueeze.changed.connect(on_t_fast_squeeze_changed)
	%TFastRest.changed.connect(on_t_fast_rest_changed)
	%Goal.changed.connect(on_goal_changed)
	update_kegel_time()

func on_n_reps_slow_changed(new_value):
	Globals.n_reps_slow = new_value
	update_kegel_time()

func on_n_reps_fast_changed(new_value):
	Globals.n_reps_fast = new_value
	update_kegel_time()

func on_t_slow_squeeze_changed(new_value):
	Globals.t_slow_squeeze = new_value
	update_kegel_time()

func on_t_slow_rest_changed(new_value):
	Globals.t_slow_rest = new_value
	update_kegel_time()

func on_t_fast_squeeze_changed(new_value):
	Globals.t_fast_squeeze = new_value
	update_kegel_time()

func on_t_fast_rest_changed(new_value):
	Globals.t_fast_rest = new_value
	update_kegel_time()

func _on_order_button_item_selected(index: int) -> void:
	Globals.order = index

func on_goal_changed(new_value):
	Globals.goal = new_value
	goal_changed.emit()

func _on_speaker_option_toggled(toggled_on: bool) -> void:
	Globals.speaker = toggled_on

func _on_vibrate_option_toggled(toggled_on: bool) -> void:
	Globals.vibrate = toggled_on

func update_kegel_time():
	var time_slow = (Globals.t_slow_squeeze + Globals.t_slow_rest) * Globals.n_reps_slow
	var time_fast = (Globals.t_fast_squeeze + Globals.t_fast_rest) * Globals.n_reps_fast
	var time = time_slow + time_fast
	%KegelTime.text = "Total Time: %dm %ds" % [time/60, int(time)%60]
	 
