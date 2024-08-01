class_name Ritual
extends Node2D

@export var damage_amount := 5
@onready var area_2d = $Area2D

func deal_damage():
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy : HealthComponent = body.get_node("HealthComponent")
			enemy.take_damage(damage_amount)
