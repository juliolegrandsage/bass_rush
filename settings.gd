extends Node

const FILE_PATH := "user://settings.ini"
const MUSIC_BUS_INDEX := 1

var config := ConfigFile.new()
var music_volume: float = 1.0  # valeur linéaire, 0.0 à 1.0

func _ready() -> void:
	if !FileAccess.file_exists(FILE_PATH):
		config.set_value("audio", "music_volume", 0.5)
		
		#inputs
		config.set_value("keybinding", "ui_up", "Pad up")
		config.set_value("keybinding", "ui_down", "Pad down")
		config.set_value("keybinding", "ui_left", "Pad left")
		config.set_value("keybinding", "ui_right", "Pad right")
		config.set_value("keybinding", "shoot", "X")
		config.set_value("keybinding", "dash", "LT")
		config.set_value("keybinding", "grapple", "RT")
		
		config.save(FILE_PATH)
	else:
		config.load(FILE_PATH)

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(FILE_PATH)

func load_audio_settings():
	music_volume = config.get_value("audio", "music_volume")
	get_tree().get_first_node_in_group("music_player").volume_linear = config.get_value("audio", "music_volume")

	return music_volume
	
func save_keybinding(action: String, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
		
	config.set_value("keybinding", action, event_str)
	config.save(FILE_PATH)
	
func load_keybinding():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	return keybindings
	
