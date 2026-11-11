extends CanvasLayer

@onready var dialogue_box: Control = $DialogueBox
@onready var text: Label = $DialogueBox/Text


var dialogue_line: Array[String] = []
var current_line_index: int = 0
var is_dialogue_active = false

func _ready() -> void:
	pass
