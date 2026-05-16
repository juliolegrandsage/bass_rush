extends CharacterBody2D


@export var SPEED = 300.0

@export var direction := 1

func _physics_process(delta: float) -> void:
	velocity = Vector2(direction * SPEED, 0)
	move_and_slide()
	



func _on_timer_timeout() -> void:
	queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("enemies"):
		queue_free()
	if body.is_in_group("player"):
		body.take_damage(2)
		
