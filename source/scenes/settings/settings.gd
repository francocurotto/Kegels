## Settings script. Handles the the modification and updating of the app's
## settings and options
extends Control

#region signals
signal goal_changed
#endregion

#region builtin function
func _ready() -> void:
	# update settings/options values with the ones from Globals
	%NRepsSlow.value = Globals.n_reps_slow
	%NRepsFast.value = Globals.n_reps_fast
	%TSlowSqueeze.value = Globals.t_slow_squeeze
	%TSlowRest.value = Globals.t_slow_rest
	%TFastSqueeze.value = Globals.t_fast_squeeze
	%TFastRest.value = Globals.t_fast_rest
	%OrderButton.selected = Globals.order
	%DailyGoal.value = Globals.daily_goal
	%SpeakerOption.button_pressed = Globals.speaker
	%VibrateOption.button_pressed = Globals.vibrate
	%AnimantionButton.selected = Globals.animation
	# signals connections
	%NRepsSlow.changed.connect(on_n_reps_slow_changed)
	%NRepsFast.changed.connect(on_n_reps_fast_changed)
	%TSlowSqueeze.changed.connect(on_t_slow_squeeze_changed)
	%TSlowRest.changed.connect(on_t_slow_rest_changed)
	%TFastSqueeze.changed.connect(on_t_fast_squeeze_changed)
	%TFastRest.changed.connect(on_t_fast_rest_changed)
	%DailyGoal.changed.connect(on_daily_goal_changed)
		# change dropdown menus fontsize
	%OrderButton.get_popup().add_theme_font_size_override("font_size", 30)
	%AnimantionButton.get_popup().add_theme_font_size_override("font_size", 30)
	# update the kegel time with default settings
	update_kegel_time()
#endregion

#region signals callbacks
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

func on_daily_goal_changed(new_value):
	Globals.daily_goal = new_value
	goal_changed.emit()

func _on_speaker_option_toggled(toggled_on: bool) -> void:
	Globals.speaker = toggled_on

func _on_vibrate_option_toggled(toggled_on: bool) -> void:
	Globals.vibrate = toggled_on

func _on_animantion_button_item_selected(index: int) -> void:
	Globals.animation = index as Tween.TransitionType
#endregion

#region private functions
## update the label on kegel exercise total time, given the kegel settings.
func update_kegel_time():
	var time_slow = (Globals.t_slow_squeeze + Globals.t_slow_rest) * Globals.n_reps_slow
	var time_fast = (Globals.t_fast_squeeze + Globals.t_fast_rest) * Globals.n_reps_fast
	var total_time = time_slow + time_fast
	%KegelTime.text = "Total Time: %dm %ds" % [total_time/60, int(total_time)%60]
#endregion
