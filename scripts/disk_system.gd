extends Resource
class_name DiskSystem

@export var ogg_file_path : String
@export var music_name : String
@export var audio_settings_file = Settings.FILE_PATH
@export var disk_cover : Texture

const file_path = "user://progress.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
