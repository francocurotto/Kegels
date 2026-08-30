extends Node

# default values
var n_reps_slow = 10
var n_reps_fast = 10
var t_slow_squeeze = 5.0
var t_slow_rest = 5.0
var t_fast_squeeze = 1.0
var t_fast_rest = 1.0
var speaker = true
var vibrate = true

# config file
var config = ConfigFile.new()

func _ready():
	# load data from a file
	var err = config.load("res://settings.cfg")
	if err != OK:
		return
	# load data to variables
	n_reps_slow = config.get_value("settings", "n_reps_slow")
	n_reps_fast = config.get_value("settings", "n_reps_fast")
	t_slow_squeeze = config.get_value("settings", "t_slow_squeeze")
	t_slow_rest = config.get_value("settings", "t_slow_rest")
	t_fast_squeeze = config.get_value("settings", "t_fast_squeeze")
	t_fast_rest = config.get_value("settings", "t_fast_rest")
	speaker = config.get_value("options", "speaker")
	vibrate = config.get_value("options", "vibrate")
