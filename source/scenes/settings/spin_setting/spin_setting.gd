## Spinbox script. Control for setting numerical values, with optional 
## informational label on top.
@tool
extends VBoxContainer

#region signals
signal changed
#endregion

#region export variables
## Text to indicate the setting information.
@export var text: String = "": 
	set(_text):
		text = _text
		$Label.text = text

## Suffix text in spinbox numerical value.
@export var suffix: String = "":
	set(_suffix):
		suffix = _suffix
		$SpinBox.suffix = suffix

## Maximum allowed value for spinbox.
@export var max_value: int = 10:
	set(_max_value):
		max_value = _max_value
		$SpinBox.max_value = max_value

## true: show text.
@export var show_label: bool = true:
	set(_show_label):
		show_label = _show_label
		$Label.visible = show_label
#endregion

#region public variables
## Numerical value of spinbox.
var value: int = 1:
	set(_value):
		value = _value
		$SpinBox.value = value
#endregion

#region builtin functions
func _ready() -> void:
	# remove interaction with spinbox's LineEdit
	var lineedit = $SpinBox.get_line_edit()
	lineedit.focus_mode = Control.FOCUS_NONE
	lineedit.selecting_enabled = false
	lineedit.virtual_keyboard_enabled = false
#endregion

#region signals callbacks
func _on_spin_box_value_changed(new_value: float) -> void:
	changed.emit(new_value)
#endregion
