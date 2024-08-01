extends CharacterBody2D

@export_category("Damage")
@export var sword_damage := 2
@export_category("Speed")
@export var speed := 4
@export_category("Ritual")
@export var ritual_damage := 2
@export var ritual_interval := 15.0
@export var ritual_scene : PackedScene

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var sword_area : Area2D = $SwordArea
@onready var hit_box_area : Area2D = $HitBoxArea
@onready var health_component : HealthComponent = $HealthComponent

var input_vector := Vector2.ZERO

var is_running := false
var was_running := false
var is_attaking := false
var attack_cooldown := 0.0
var hit_box_cooldown := 0.0
var ritual_cooldown := ritual_interval

func _process(delta) -> void:			
	GameManager.player_position = position	
	read_input()
	play_movement_animations()

	update_attack_cooldown(delta)
	if(Input.is_action_just_pressed("attack")):		
		attack()
	
	hit_box_detection(delta)
	
	update_ritual_cooldown(delta)


func update_attack_cooldown(delta: float) -> void:
	if is_attaking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attaking = false
			is_running = false
			animation_player.play("idle")

func update_ritual_cooldown(delta: float) -> void:	
	ritual_cooldown -= delta
	if ritual_cooldown <= 0.0:
		ritual_cooldown = ritual_interval
		var ritual = ritual_scene.instantiate()
		ritual.damage_amount = ritual_damage
		add_child(ritual)
		

func _physics_process(_delta: float) -> void:
	var target_velocity = input_vector * speed * 100;

	#slow down if attaking
	if is_attaking:
		target_velocity *= 0.25
	
	velocity = lerp(velocity,target_velocity,0.5)
	move_and_slide()		

func play_movement_animations():
	if is_attaking: return
	if(input_vector.x < 0):
		sprite_2d.flip_h = true
	elif(input_vector.x > 0):
		sprite_2d.flip_h = false		

	if not is_attaking:
		if(was_running != is_running):
			if is_running:
				animation_player.play("run")		
			else: 
				animation_player.play("idle")		


func read_input():
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down", 0.10);
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func attack() -> void:
	if is_attaking: return

	animation_player.play("atk_side_1")
	
	attack_cooldown = 0.6
	is_attaking = true

func deal_damage() -> void:
	var bodies = sword_area.get_overlapping_bodies()	
	for body in bodies:
		if body.is_in_group("enemies"): 
			var enemy : HealthComponent = body.get_node("HealthComponent")
			var direction_to_enemy = (enemy.parent.position - position).normalized()
			var attack_direction : Vector2
			if(sprite_2d.flip_h):
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)			
			if dot_product > 0.4:
				enemy.take_damage(sword_damage)


func hit_box_detection(delta: float) -> void:

	#Timer
	hit_box_cooldown -= delta
	if hit_box_cooldown > 0 : return

	#half second delay
	hit_box_cooldown = 0.5

	var bodies = hit_box_area.get_overlapping_bodies()	
	for body in bodies:
		if body.is_in_group("enemies"): 
			health_component.take_damage(1)

