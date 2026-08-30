@tool
extends VBoxContainer

signal changed

@export var text: String = "": 
	set(_text):
		text = _text
		$Label.text = text
		
@export var suffix: String = "":
	set(_suffix):
		suffix = _suffix
		$SpinBox.suffix = suffix

@export var max_value: int = 10:
	set(_max_value):
		max_value = _max_value
		$SpinBox.max_value = max_value

var value: int = 1:
	set(_value):
		value = _value
		$SpinBox.value = value

func _ready() -> void:
	$SpinBox.get_line_edit().focus_mode = Control.FOCUS_NONE

func _on_spin_box_value_changed(new_value: float) -> void:
	changed.emit(new_value)
