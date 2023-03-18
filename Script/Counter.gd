extends Control
class_name Screen

var counter: int = 0

@onready var output: Label = $MarginContainer/MarginContainer/Counter

func increment_count():
	counter += 1
	output.text = str(counter)
