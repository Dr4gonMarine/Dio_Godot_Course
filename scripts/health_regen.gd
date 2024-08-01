extends Node2D

@export var heal_amount := 20

func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var player :HealthComponent= body.get_node("HealthComponent")
		player.heal(heal_amount)
		queue_free()
