extends Node2D

func _ready() -> void:
	$CharacterBody2D.health = 20
	Settings.load_audio_settings()

func _on_character_body_2d_player_dead() -> void:
	get_tree().reload_current_scene()


func _on_die_t_imer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/demoending.tscn")
