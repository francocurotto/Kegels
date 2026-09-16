## Stats script. Handles stats rendering.
extends Control

#region constants
## Colors for exercise indicator.
const GOAL_COLORS = {
	-1.0 : Color("#f0f8ff"), # daily goal not yet met color
	 0.0 : Color("#5d8aa8"), # daily goal met color
	 1.0 : Color("#a4c639")  # daily goal over met color 
}
#endregion

#region builtin functions
func _ready() -> void:
	var string = FileAccess.get_file_as_string(Globals.STATS_FILENAME)
	var parsed = JSON.parse_string(string)
	if parsed is Dictionary:
		Globals.stats = parsed
	else:
		Globals.stats = {}
	update_stats_dates()
	render_stats()
#endregion

#region public functions
## Render the stats from from the stats dictionary in a grid layout.
func render_stats():
	# remove previous render
	for child in %StatsGrid.get_children():
		child.queue_free()
	# get data from stats
	var dates = Globals.stats.keys()
	var counts = Globals.stats.values()
	var max_count = counts.max()
	%StatsGrid.columns = max_count + 1
	# iterate over every date to and fill grid
	for i in Globals.stats.size():
		var date = dates[i]
		var count = counts[i]
		var color = GOAL_COLORS[sign(count-Globals.daily_goal)]
		%StatsGrid.add_child(create_date_label(date))
		for j in count:
			%StatsGrid.add_child(create_count_rect(color))
		for j in max_count-count:
			%StatsGrid.add_child(create_blank_rect())
#endregion

#region private functions
## Update the stats dates so that it is synced with the current date.
func update_stats_dates():
	# case stats empty: add current date and 0 count
	if Globals.stats.is_empty():
		Globals.stats[Time.get_date_string_from_system()] = 0
		return
	# case stats not empty: fill dates until synced with current date
	var dates = Globals.stats.keys()
	var last_date_unix = Time.get_unix_time_from_datetime_string(dates[-1])
	var current_date = Time.get_date_string_from_system()
	var current_date_unix = Time.get_unix_time_from_datetime_string(current_date)
	while last_date_unix < current_date_unix:
		last_date_unix += 86400 # 1 day in seconds
		var new_date = Time.get_date_string_from_unix_time(last_date_unix)
		Globals.stats[new_date] = 0

## Return a Label node with the [param date] text.
func create_date_label(date):
	var label = Label.new()
	label.text = date.replace("-", "/")
	label.add_theme_font_size_override("font_size", 30)
	return label

## Return a ColorRect node with [param color] as its color.
func create_count_rect(color):
	var rect = ColorRect.new()
	rect.modulate = color
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return rect

## Return a blank ColorRect node.
func create_blank_rect():
	var rect = ColorRect.new()
	rect.modulate = Color(1,1,1,0)
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return rect
#endregion
