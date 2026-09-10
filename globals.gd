extends Node

# default values
var n_reps_slow = 10
var n_reps_fast = 10
var t_slow_squeeze = 5.0
var t_slow_rest = 5.0
var t_fast_squeeze = 1.0
var t_fast_rest = 1.0
var order = 0
var goal = 3
var speaker = true
var vibrate = true

# stats
var stats

# config file
var config = ConfigFile.new()

func _ready():
	# load data from a file
	config.load("user://settings.cfg")
	# load data to variables
	n_reps_slow = config.get_value("settings", "n_reps_slow", n_reps_slow)
	n_reps_fast = config.get_value("settings", "n_reps_fast", n_reps_fast)
	t_slow_squeeze = config.get_value("settings", "t_slow_squeeze", t_slow_squeeze)
	t_slow_rest = config.get_value("settings", "t_slow_rest", t_slow_rest)
	t_fast_squeeze = config.get_value("settings", "t_fast_squeeze", t_fast_squeeze)
	t_fast_rest = config.get_value("settings", "t_fast_rest", t_fast_rest)
	order = config.get_value("settings", "order", order)
	goal = config.get_value("settings", "goal", goal)
	speaker = config.get_value("options", "speaker", speaker)
	vibrate = config.get_value("options", "vibrate", vibrate)
