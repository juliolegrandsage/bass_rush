extends Node

var music_player: AudioStreamPlayer
@export var music_slider: HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player = get_tree().get_first_node_in_group("music_player")

func set_volume(value: float) -> void:
	if music_player != null:
		music_player.volume_db = linear_to_db(value)
		
func get_volume():
	if music_player != null:
		return db_to_linear(music_player.volume_db)
	return 1.0	
