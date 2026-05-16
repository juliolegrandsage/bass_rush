class_name Projectile
extends CharacterBody2D

@export var SPEED = 400
@export var direction := 1



func _physics_process(delta):
	velocity = Vector2(direction * SPEED, 0)
	move_and_slide()

		


func _on_timer_timeout() -> void:
	print("Destroyed")
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(2)
		print(body.health)
		queue_free()
	elif body.is_in_group("tilemap"):
		queue_free()
