extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveHandler.save_current_level()
	Settings.load_audio_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#get_tree().get_first_node_in_group("music_player").volume_linear = Settings.config.get_value("audio", "music_volume")
	pass
