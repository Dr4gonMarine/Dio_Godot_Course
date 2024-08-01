extends Node2D

@export var speed := 1.0

var entity: Node2D
var animated_sprite2d: AnimatedSprite2D


func _ready() -> void:
	entity = get_parent()
	animated_sprite2d = entity.get_node("AnimatedSprite2D")


func _physics_process(_delta: float) -> void:
	var direction = GameManager.player_position - entity.position
	var input_vector = direction.normalized()
	entity.velocity = input_vector * speed * 100
	entity.move_and_slide()

	if input_vector.x > 0:
		animated_sprite2d.flip_h = false
	else:
		animated_sprite2d.flip_h = true
