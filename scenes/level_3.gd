extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveHandler.save_current_level()
	Settings.load_audio_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		get_tree().reload_current_scene()
