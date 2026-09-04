extends Control

func _ready() -> void:
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS
func resume():
	get_tree().paused = false
	
func pause():
	get_tree().paused = true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("start"):
		if get_tree().paused:
			visible = false
			resume()
		else:
			visible = true
			pause()

	print(get_tree().paused)
