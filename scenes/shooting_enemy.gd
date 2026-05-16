extends CharacterBody2D


@onready var target

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

const STOP_DIST = 100.0

var health = 5 

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	
	
	
func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	var dist = position.distance_to(target.position)
	if dist > STOP_DIST:
		var dir = (target.position - position).normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO
		
	look_at(target.position)
	move_and_slide()
	
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
func take_damage(damage):
	health -= damage
