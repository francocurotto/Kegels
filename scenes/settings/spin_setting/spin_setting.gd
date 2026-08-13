@tool
extends HBoxContainer

signal changed

@export var text: String = "": 
	set(_text):
		text = _text
		$Label.text = text
		
@export var suffix: String = "":
	set(_suffix):
		suffix = _suffix
		$SpinBox.suffix = suffix

var value: int = 1:
	set(_value):
		value = _value
		$SpinBox.value = value

func _on_spin_box_value_changed(new_value: float) -> void:
	changed.emit(new_value)
