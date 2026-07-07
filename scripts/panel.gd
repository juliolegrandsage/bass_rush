extends Area2D

var canInteract = false
var hasEnteredPanelZone = false

@onready var dialogue_box = $"../DialogueManager"

@export var message = ""

func _process(delta: float) -> void:
	if hasEnteredPanelZone:
		if canInteract and Input.is_action_just_pressed("shoot"):
			show_dialogue()
		elif !canInteract and Input.is_action_just_pressed("shoot"):
			quit_dialogue()
			hasEnteredPanelZone = false
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		canInteract = true
		hasEnteredPanelZone = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		canInteract = false

func show_dialogue():
	dialogue_box.dialogue = message
	dialogue_box.show_dialogue()
	canInteract = false
	print("message")
	
func quit_dialogue():
	dialogue_box.quit_dialogue()
	canInteract = true
	
	
