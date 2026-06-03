extends Control

@export var label_text = "Hello world"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/Label2.text = label_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_tuto_card"):
		visible = false
	$Panel/Label2.text = label_text
