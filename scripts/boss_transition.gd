extends Area2D

@export var boss_scene: String

@export var canvas_layer: CanvasLayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_transition()


func start_transition():
	$Timer.start()
	if canvas_layer != null:
		canvas_layer.get_node("ColorRect/AnimationPlayer").play("fadeout")
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(boss_scene)
