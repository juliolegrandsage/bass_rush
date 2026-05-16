extends Control

func _ready() -> void:
	$boss1.grab_focus()

func _on_boss_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bosses_scenes/boss1.tscn")



func _on_boss_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bosses_scenes/boss2.tscn")



func _on_boss_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bosses_scenes/boss_3.tscn")
