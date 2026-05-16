extends Node2D

@export var rest_length := 60.0
@export var stiffness := 50.0
@export var damping := 4.0

@onready var player: CharacterBody2D = get_parent()
@onready var ray := $RayCast2D
@onready var rope := $Line2D

var launched := false
var target := Vector2.ZERO

func _physics_process(delta):
	if Input.is_action_just_pressed("grapple"):
		launch(delta)
	if Input.is_action_just_released("grapple"):
		retract()

	if launched:
		handle_grapple(delta)

func launch(delta):
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()
		$RayCast2D/CPUParticles2D.emitting = true
		var dir = player.global_position.direction_to(target)
		player.velocity = dir * 600
		
		
func retract():
	launched = false
	rope.hide()

func handle_grapple(delta):
	var dir = player.global_position.direction_to(target)
	var dist = player.global_position.distance_to(target)
	var displacement = dist - rest_length

	var spring_force = stiffness * displacement
	var vel_along_rope = player.velocity.dot(dir)
	var damp_force = damping * vel_along_rope

	var total_force = dir * (spring_force - damp_force)
	player.velocity += total_force * delta

	update_rope()

func update_rope():
	rope.set_point_position(1, to_local(target))
	
func _process(delta: float) -> void:
	if $"../AnimatedSprite2D".flip_h == true:
		$RayCast2D.target_position.x = -100
	elif $"../AnimatedSprite2D".flip_h == false:
		$RayCast2D.target_position.x = 100
