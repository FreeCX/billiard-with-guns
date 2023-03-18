extends Node2D
class_name Screen

var counter: int = 0

@onready var output: Label = $MarginContainer/HSplitContainer/counter

func increment_count():
	counter += 1
	output.text = str(counter)
