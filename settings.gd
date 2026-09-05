extends Node

const FILE_PATH := "user://settings.ini"
const MUSIC_BUS_INDEX := 1

var config := ConfigFile.new()
var music_volume: float = 1.0  # valeur linéaire, 0.0 à 1.0

func _ready() -> void:
	if !FileAccess.file_exists(FILE_PATH):
		config.set_value("audio", "music_volume", 0.5)
		config.save(FILE_PATH)
	else:
		config.load(FILE_PATH)



func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(FILE_PATH)

func load_audio_settings():
	music_volume = config.get_value("audio", "music_volume", 0.5)
	return music_volume
