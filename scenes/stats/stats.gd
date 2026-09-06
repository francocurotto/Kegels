extends Control

func _ready() -> void:
	var string = FileAccess.get_file_as_string("user://stats.json")
	if string == "":
		Globals.stats = {}
	else:
		Globals.stats = JSON.parse_string(string)
	update_date()
	render_stats()

func update_date():
	if Globals.stats.is_empty():
		Globals.stats[Time.get_date_string_from_system()] = 0
		return
	var dates = Globals.stats.keys()
	var last_date = Time.get_unix_time_from_datetime_string(dates[-1])
	var current_date = Time.get_unix_time_from_system()
	while last_date+86400 < current_date:
		last_date += 86400 # 1 day in seconds
		var new_date = Time.get_date_string_from_unix_time(last_date)
		Globals.stats[new_date] = 0

func render_stats():
	var dates = Globals.stats.keys()
	var counts = Globals.stats.values()
	var max_count = counts.max()
	%StatsGrid.columns = max_count + 1
	for i in Globals.stats.size():
		var date = dates[i]
		var count = counts[i]
		%StatsGrid.add_child(create_date_label(date))
		for j in count:
			%StatsGrid.add_child(create_count_rect())
		for j in max_count-count:
			%StatsGrid.add_child(create_blank_rect())

func create_date_label(date):
	var label = Label.new()
	label.text = date
	return label

func create_count_rect():
	var rect = ColorRect.new()
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return rect

func create_blank_rect():
	var rect = create_count_rect()
	rect.modulate = Color(1,1,1,0)

func on_new_kegel():
	for child in %StatsGrid.get_children():
		child.queue_free()
	render_stats()
