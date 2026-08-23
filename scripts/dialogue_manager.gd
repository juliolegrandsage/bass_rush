extends CanvasLayer

@export var new_text : String
@export var wait_time : float

@export var label : Label


	
func _process(delta: float) -> void:
	pass
func show_dialogue() -> void:
	label.text = new_text
	visible = true

	Engine.time_scale = 0


func quit_dialogue():
	visible = false
	Engine.time_scale = 1
	print("quiited")
