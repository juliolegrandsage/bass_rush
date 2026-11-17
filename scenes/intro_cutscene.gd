extends Node2D


func _on_timer_timeout() -> void:
	$Sprite2D/AnimationPlayer.play("forward")
	$shipSFX.play()


func _on_timer_2_timeout() -> void:
	$Bassrushdemologo/AnimationPlayer.play("show")
	$Timer2.stop()

func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
		
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		$CanvasLayer/Label.visible = true
	
