# Script de la lance du boss 2

extends CharacterBody2D

var SPEED = -500
var is_planted := false

@onready var boss_2_controller = get_tree().get_first_node_in_group("boss_controller")
func _ready() -> void:
	velocity = Vector2(SPEED, 0)


func _physics_process(delta: float) -> void:
	move_and_slide()

func _process(delta: float) -> void:
	if is_planted == true:
		velocity = Vector2.ZERO
	if boss_2_controller.current_phase == boss_2_controller.phases.phase2:
		SPEED = -700



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("tilemap"):
		velocity = Vector2.ZERO
		is_planted = true
	elif body.is_in_group("player") and is_planted == false:
		if boss_2_controller.current_phase == boss_2_controller.phases.phase1:
			body.take_damage(2)
		elif boss_2_controller.current_phase == boss_2_controller.phases.phase2:
			body.take_damage(5)
		queue_free()
 	


func _on_timer_timeout() -> void:
	queue_free()
