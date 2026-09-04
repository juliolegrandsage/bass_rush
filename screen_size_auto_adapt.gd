extends Node
var r36s_screen_size : Vector2i = Vector2i(640, 480)
var screen_size : Vector2i

func _ready() -> void:
	get_screen_res()
	if screen_size != r36s_screen_size:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
func _process(delta: float) -> void:
	if screen_size == r36s_screen_size:
		var cams = get_tree().get_nodes_in_group("camera")
		for cam in cams:
			cam.zoom = Vector2(0.6, 0.6)
	else:
		var cams = get_tree().get_nodes_in_group("camera")
		for cam in cams:
			cam.zoom = Vector2(2, 2)
	
func get_screen_res():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(screen_size)
	screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	print(screen_size)
	DisplayServer.window_set_size(screen_size)
