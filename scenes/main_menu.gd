extends Node2D




func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")	



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/infinite_mode.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		1,
		linear_to_db($CanvasLayer/Panel/VBoxContainer/HSlider.value)
	)
