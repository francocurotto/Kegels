extends Node

#region filenames
const CONFIG_FILENAME = "user://settings.cfg"
const STATS_FILENAME = "user://stats.json"
#endregion

#region default values settings
var n_reps_slow = 10 ## Number of repetition for slow kegels
var n_reps_fast = 10 ## Number or repetitions for fast kegels
var t_slow_squeeze = 5.0 ## Duration of squeeze on slow kegels
var t_slow_rest = 5.0 ## Duration of rest on slow kegels
var t_fast_squeeze = 1.0 ## Duration of squeeze on fast kegels
var t_fast_rest = 1.0 ## Duration of rest on fast kegels
var order = 0 ## 0: slow then fast kegels, 1: fast then slow kegels
var daily_goal = 3.0 ## Daily goal for number of kegel exercises
#endregion

#region default values options
var speaker = true ## true: make sound on kegel excercises
var vibrate = true ## true: vibrate on kegel excercises
var animation = Tween.TRANS_CUBIC ## Type of animation on visual cue
#endregion

#region data storage
var stats ## Dictionary with the statistics of excercises
var config = ConfigFile.new() ## Configuration file to save settings and options
#endregion

#region built-in functions
func _ready():
	# load settings from a file
	config.load(CONFIG_FILENAME)
	# assign settings/options to variables
	n_reps_slow = config.get_value("settings", "n_reps_slow", n_reps_slow)
	n_reps_fast = config.get_value("settings", "n_reps_fast", n_reps_fast)
	t_slow_squeeze = config.get_value("settings", "t_slow_squeeze", t_slow_squeeze)
	t_slow_rest = config.get_value("settings", "t_slow_rest", t_slow_rest)
	t_fast_squeeze = config.get_value("settings", "t_fast_squeeze", t_fast_squeeze)
	t_fast_rest = config.get_value("settings", "t_fast_rest", t_fast_rest)
	order = config.get_value("settings", "order", order)
	daily_goal = config.get_value("settings", "daily_goal", daily_goal)
	speaker = config.get_value("options", "speaker", speaker)
	vibrate = config.get_value("options", "vibrate", vibrate)
	animation = config.get_value("options", "animation", animation)
#endregion
