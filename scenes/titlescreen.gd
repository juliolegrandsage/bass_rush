extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		$bleep.play()
		$LaunchGame.start()


func _on_launch_game_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
