extends Area2D

var canInteract = false
var hasEnteredPanelZone = false
@onready var x_indicator = $"indicators"
@onready var dialogue_box = $"../CanvasLayer/DialogueManager"
@onready var player = $"../CharacterBody2D"

@export var message = ""

func _ready() -> void:
	x_indicator.visible = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if canInteract and dialogue_box.visible == false:
			show_dialogue_panel()
		elif canInteract and dialogue_box.visible == true:
			quit_dialogue_panel()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		canInteract = true
		dialogue_box.new_text = ""
		dialogue_box.new_text = message
		


func show_dialogue_panel():
	dialogue_box.new_text = ""
	dialogue_box.new_text = message
	dialogue_box.show_dialogue()

func quit_dialogue_panel():
	dialogue_box.new_text = ""
	dialogue_box.new_text = message
	dialogue_box.quit_dialogue()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		canInteract = false
		dialogue_box.new_text = ""
		dialogue_box.new_text = message
