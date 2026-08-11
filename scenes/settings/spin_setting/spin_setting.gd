@tool
extends HBoxContainer

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
