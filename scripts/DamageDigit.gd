extends Node2D

@export var value := 0

func _ready() -> void:
	%Label.text = str(value)
