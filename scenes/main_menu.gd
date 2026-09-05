extends Node2D

@export var music_player: AudioStreamPlayer
func _ready() -> void:	
	
	Settings.config.load(Settings.FILE_PATH)
	music_player.volume_db = linear_to_db(Settings.config.get_value("audio" ,"music_volume"))
	$CanvasLayer/Panel/VBoxContainer/HSlider.value = Settings.config.get_value("audio", "music_volume")
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")	



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/infinite_mode.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	music_player.volume_db = linear_to_db(value)
	Settings.save_audio_settings("music_volume", value)
	
