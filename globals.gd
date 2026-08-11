extends Node

# default values
var n_reps_slow = 10
var n_reps_fast = 10
var t_reps_slow = 5.0
var t_reps_fast = 1.0

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
	t_reps_slow = config.get_value("settings", "t_reps_slow")
	t_reps_fast = config.get_value("settings", "t_reps_fast")
