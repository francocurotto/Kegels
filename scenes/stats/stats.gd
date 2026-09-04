extends Control

func _ready() -> void:
	var string = FileAccess.get_file_as_string("user://stats.json")
	if string == "":
		Globals.stats = {}
	else:
		Globals.stats = JSON.parse_string(string)
	update_date()

func update_date():
	if Globals.stats.is_empty():
		Globals.stats[Time.get_date_string_from_system()] = 0
		return
	var dates = Globals.stats.keys()
	var last_date = Time.get_unix_time_from_datetime_string(dates[-1])
	var current_date = Time.get_unix_time_from_system()
	print(last_date)
	print(current_date)
	while last_date+86400 < current_date:
		last_date += 86400 # 1 day in seconds
		var new_date = Time.get_date_string_from_unix_time(last_date)
		Globals.stats[new_date] = 0
