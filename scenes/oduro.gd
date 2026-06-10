extends CharacterBody2D


var SPEED = 100.0

var facing_right = false

@onready var player = get_tree().get_first_node_in_group("player")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_player_detected:bool
var direction = -1
var health = 5

var animator = null

func _ready() -> void:
	animator = $AnimatedSprite2D
	animator.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = SPEED * direction

	# petit offset de sécurité
	if is_on_floor() and !$RayCast2D.is_colliding():
		flip()
	print(direction, " | ", $RayCast2D.target_position, " is colliding : ", str($RayCast2D.is_colliding()))
	move_and_slide()
func flip():
	direction *= -1
	$AnimatedSprite2D.flip_h = direction > 0
	$RayCast2D.target_position.x = abs($RayCast2D.target_position.x) * direction
