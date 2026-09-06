extends Control

var audioplayer = AudioStreamPlayer

func _ready() -> void:
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	Settings.config.load(Settings.FILE_PATH)
	if get_tree().get_first_node_in_group("music_player") != null:
		audioplayer = get_tree().get_first_node_in_group("music_player")
	$Panel/VBoxContainer/HSlider.grab_focus(true)
	$Panel/VBoxContainer/HSlider.value = Settings.config.get_value("audio", "music_volume")

func resume():
	get_tree().paused = false
	
func pause():
	get_tree().paused = true
	$Panel/VBoxContainer/HSlider.grab_focus(true)



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("start"):
		if get_tree().paused:
			visible = false
			resume()
		else:
			visible = true
			pause()

	print(get_tree().paused)


func _on_h_slider_value_changed(value: float) -> void:
	audioplayer.volume_db = linear_to_db(value)
	Settings.save_audio_settings("music_volume", value)
	



func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_continue_pressed() -> void:
	resume()
