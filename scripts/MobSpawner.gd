extends Node2D

class_name MobSpawner

@onready var path_follow_2d = %PathFollow2D

@export var mobs : Array[PackedScene]
var mobs_per_minute : float = 60

var cooldown := 0.0

func _process(delta):
	#Timer
	cooldown -= delta
	if cooldown > 0 : return

	var interval = 60.0 / mobs_per_minute
	cooldown = interval    
	var mob = mobs[randi_range(0, mobs.size() - 1)].instantiate()
	
	#check if its outside the map (colliding with something)
	var point = get_random_spawn_position()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result : Array = world_state.intersect_point(parameters,1)
	if not result.is_empty() : return
	mob.global_position = get_random_spawn_position()	
	get_parent().add_child(mob)

func get_random_spawn_position() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
