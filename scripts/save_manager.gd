extends Node

var config = ConfigFile.new()
var path = "user://save.cfg"


func _ready() -> void:

	print(ProjectSettings.globalize_path("user://"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
