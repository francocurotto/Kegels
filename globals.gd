extends Node

# default values
var n_reps_slow = 10
var n_reps_fast = 10
var t_slow_squeeze = 5.0
var t_slow_rest = 5.0
var t_fast_squeeze = 1.0
var t_fast_rest = 1.0
var order = 0
var speaker = true
var vibrate = true

# stats
var stats

# config file
var config = ConfigFile.new()

func _ready():
	# load data from a file
	var err = config.load("user://settings.cfg")
	if err != OK:
		create_default_config()
	# load data to variables
	n_reps_slow = config.get_value("settings", "n_reps_slow")
	n_reps_fast = config.get_value("settings", "n_reps_fast")
	t_slow_squeeze = config.get_value("settings", "t_slow_squeeze")
	t_slow_rest = config.get_value("settings", "t_slow_rest")
	t_fast_squeeze = config.get_value("settings", "t_fast_squeeze")
	t_fast_rest = config.get_value("settings", "t_fast_rest")
	order = config.get_value("settings", "order")
	speaker = config.get_value("options", "speaker")
	vibrate = config.get_value("options", "vibrate")

func create_default_config():
	config.set_value("settings", "n_reps_slow", n_reps_slow)
	config.set_value("settings", "n_reps_fast", n_reps_fast)
	config.set_value("settings", "t_slow_squeeze", t_slow_squeeze)
	config.set_value("settings", "t_slow_rest", t_slow_rest)
	config.set_value("settings", "t_fast_squeeze", t_fast_squeeze)
	config.set_value("settings", "t_fast_rest", t_fast_rest)
	config.set_value("settings", "order", order)
	config.set_value("options", "speaker", speaker)
	config.set_value("options", "vibrate", vibrate)
