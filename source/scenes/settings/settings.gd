## Settings script. Handles the the modification and updating of the app's
## settings and options
extends Control

#region signals
signal goal_changed
signal stats_imported
#endregion

#region private variables
var save_dialog: FileDialog
var load_dialog: FileDialog
#endregion

#region builtin function
func _ready() -> void:
	# import data object
	save_dialog = _make_dialog(FileDialog.FILE_MODE_SAVE_FILE)
	save_dialog.current_file = "save.json"
	save_dialog.file_selected.connect(_on_save_file_selected)
	# export data object
	load_dialog = _make_dialog(FileDialog.FILE_MODE_OPEN_FILE)
	load_dialog.file_selected.connect(_on_load_file_selected)
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

func _on_save_button_pressed() -> void:
	save_dialog.popup_file_dialog()

func _on_load_button_pressed() -> void:
	load_dialog.popup_file_dialog()

func _on_save_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Save failed: " + error_string(FileAccess.get_open_error()))
		return
	file.store_string(JSON.stringify(Globals.stats, "\t"))
	file.close()

func _on_load_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Load failed: " + error_string(FileAccess.get_open_error()))
		return
	var json_text = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(json_text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("The selected file isn't a valid JSON dictionary.")
		return
	if not check_stats_dict(parsed):
		push_error("The selected file is not a valid stats file.")
		return
	Globals.stats = parsed
	stats_imported.emit()
#endregion

#region private functions
## update the label on kegel exercise total time, given the kegel settings.
func update_kegel_time():
	var time_slow = (Globals.t_slow_squeeze + Globals.t_slow_rest) * Globals.n_reps_slow
	var time_fast = (Globals.t_fast_squeeze + Globals.t_fast_rest) * Globals.n_reps_fast
	var total_time = time_slow + time_fast
	%KegelTime.text = "Total Time: %dm %ds" % [total_time/60, int(total_time)%60]

func _make_dialog(mode: FileDialog.FileMode) -> FileDialog:
	var dialog = FileDialog.new()
	dialog.file_mode = mode
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.use_native_dialog = true
	dialog.add_filter("*.json", "JSON files")
	add_child(dialog)
	return dialog
#endregion

func check_stats_dict(dict):
	# check key values
	for key in dict.keys():
		if typeof(key) != TYPE_STRING:
			return false
	# check counter values
	for counter in dict.values():
		# check the counter is float
		if typeof(counter) != TYPE_FLOAT:
			return false
		# check the counter is not negative
		if counter < 0:
			return false
		# check the counter is int
		if counter - int(counter) > 0:
			return false
	return true
