extends CanvasLayer

var timer := 0.0

@onready var gold_label: Label = %Gold
@onready var timer_label: Label = %Timer

func _process(delta: float) -> void:
	timer += delta
	timer_label.text = time_convert(timer)
	

func time_convert(time: float) -> String:
	var time_in_sec := floori(time)
	var seconds = time_in_sec % 60
	var minutes = time_in_sec / 60
	
	#returns a string with the format "MM:SS"
	return "%02d:%02d" % [minutes, seconds]
