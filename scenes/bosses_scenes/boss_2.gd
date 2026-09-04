extends Node2D

func _ready() -> void:
	$CharacterBody2D.health = 20


func _on_character_body_2d_player_dead() -> void:
	get_tree().reload_current_scene()
