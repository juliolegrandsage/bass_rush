extends Node2D



var autosizescreensize : Script
func _ready() -> void:
	Settings.config.load("user://settings.ini")
	if !FileAccess.file_exists(SaveHandler.save_file):
		SaveHandler.save_progress()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AudioStreamPlayer.volume_linear = Settings.config.get_value("audio", "music_volume")
	if Input.is_action_just_pressed("start"):
		$bleep.play()
		$LaunchGame.start()



func _on_launch_game_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
