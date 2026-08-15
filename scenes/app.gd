extends Control

func _ready() -> void:
	%Gym.curtain_clear = %CurtainClear
	%Gym.curtain_white = %CurtainWhite
	%Gym.train_started.connect(on_train_started)
	%Gym.train_ended.connect(on_train_ended)

func on_train_started():
	for i in $TabContainer.get_tab_count():
		$TabContainer.set_tab_disabled(i, true)

func on_train_ended():
	for i in $TabContainer.get_tab_count():
		$TabContainer.set_tab_disabled(i, false)

func _notification(event):
	if event == NOTIFICATION_WM_CLOSE_REQUEST or \
		event == NOTIFICATION_WM_GO_BACK_REQUEST:
			save_data()
			get_tree().quit()

func save_data():
	#FIXME does not work
	print("a")
	Globals.config.set_value("settings", "n_reps_slow", Globals.n_reps_slow)
	Globals.config.set_value("settings", "n_reps_fast", Globals.n_reps_fast)
	Globals.config.set_value("settings", "t_reps_slow", Globals.t_reps_slow)
	Globals.config.set_value("settings", "t_reps_fast", Globals.t_reps_fast)
