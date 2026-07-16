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
		if canInteract and not dialogue_box.visible:
			show_dialogue_panel()			
		elif dialogue_box.visible and canInteract and Engine.time_scale == 0:
			dialogue_box.quit_dialogue()
			Engine.time_scale = 1
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		canInteract = true
		hasEnteredPanelZone = true
		x_indicator.visible = true
		print(canInteract)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		canInteract = false
		x_indicator.visible = false
func show_dialogue_panel():
	dialogue_box.new_text = ""
	dialogue_box.new_text = message
	dialogue_box.show_dialogue()
