class_name HealthComponent
extends Node2D

@export_category("Life")
@export var max_health := 10
@export var health := max_health
@export var death_prefab : PackedScene
var damage_digit_prefab : PackedScene

@export_category("Drops")
@export var drop_chances : Array[float]
@export var drop_chance := 0.0
@export var drop_items : Array[PackedScene]

@onready var parent = get_parent()
@onready var health_progress_bar: ProgressBar = %HealthProgressBar
@onready var damage_digit_marker: Marker2D = %DamageDigitMarker

func _ready() -> void:
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")


func _process(delta) -> void:
	if health_progress_bar:
		health_progress_bar.max_value = max_health
		health_progress_bar.value = health 
		

func show_damge_taken(damage: int) -> void:
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = damage
	damage_digit.global_position = damage_digit_marker.global_position
	get_parent().add_sibling(damage_digit)


func take_damage(amount: int) -> void:
	health -= amount
	
	if damage_digit_marker:
		show_damge_taken(amount)

	#show damage on screen
	parent.modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(parent, "modulate", Color.WHITE, 0.2)

	if health <= 0:
		die()

func die() -> void:   
	var death_obj = death_prefab.instantiate()
	death_obj.position = parent.position 
	parent.get_parent().add_child(death_obj)
	
	if randf() <= drop_chance:
		drop_item()
	
	parent.queue_free()	

func drop_item() -> void:
	var drop_obj = get_random_item().instantiate()
	drop_obj.position = parent.position 
	parent.get_parent().add_child(drop_obj)
	
	
func get_random_item() -> PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
	
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
		
	var random_value = randf() * max_chance
	
	var needle := 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if drop_chances.size() > 1 else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
		
	return drop_items[0]

func heal(amount: int) -> void:
	if(health + amount >= max_health):
		health = max_health
	else:
		health += amount
