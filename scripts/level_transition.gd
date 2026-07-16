extends Area2D

@export var current_cam: Camera2D

@export var new_cam: Camera2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if current_cam.is_current():
			new_cam.make_current()
		elif new_cam.is_current():
			current_cam.make_current()
