## Main app script
extends Control

#region builtin functions
func _ready() -> void:
	# pass curtain nodes to gym
	%Gym.curtain_clear = %CurtainClear
	%Gym.curtain_white = %CurtainWhite
	# connections
	%Gym.train_started.connect(on_train_started)
	%Gym.train_ended.connect(on_train_ended)
	%Gym.train_ended.connect(%Stats.render_stats)
	%Settings.goal_changed.connect(%Stats.render_stats)
#endregion

#region signals callbacks
## Disabled window tabs when training starts.
func on_train_started():
	for i in $WindowTabs.get_tab_count():
		$WindowTabs.set_tab_disabled(i, true)

## Enable window tabs when training ends.
func on_train_ended():
	for i in $TabContainer.get_tab_count():
		$TabContainer.set_tab_disabled(i, false)

## Handle app closing. Save settings and stats.
func _notification(event):
	if event == NOTIFICATION_WM_CLOSE_REQUEST or \
		event == NOTIFICATION_WM_GO_BACK_REQUEST:
			save_data()
			get_tree().quit()
#endregion

#region private functions
## Save app settings/options in config file and stats in json file.
func save_data():
	# save settings/options
	Globals.config.set_value("settings", "n_reps_slow", Globals.n_reps_slow)
	Globals.config.set_value("settings", "n_reps_fast", Globals.n_reps_fast)
	Globals.config.set_value("settings", "t_slow_squeeze", Globals.t_slow_squeeze)
	Globals.config.set_value("settings", "t_slow_rest", Globals.t_slow_rest)
	Globals.config.set_value("settings", "t_fast_squeeze", Globals.t_fast_squeeze)
	Globals.config.set_value("settings", "t_fast_rest", Globals.t_fast_rest)
	Globals.config.set_value("settings", "order", Globals.order)
	Globals.config.set_value("settings", "daily_goal", Globals.daily_goal) 
	Globals.config.set_value("options", "speaker", Globals.speaker)
	Globals.config.set_value("options", "vibrate", Globals.vibrate)
	Globals.config.set_value("options", "animation", Globals.animation)
	Globals.config.save(Globals.CONFIG_FILENAME)
	# save stats
	var string = JSON.stringify(Globals.stats)
	var file = FileAccess.open(Globals.STATS_FILENAME, FileAccess.WRITE)
	file.store_string(string)
#endregion
