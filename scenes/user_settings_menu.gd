extends Control


@onready var inpt_btn = preload("res://scenes/inpt_btn.tscn")
@onready var action_list = $Panel/VBoxContainer

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_sections = {
	"ui_up": "Up",
	"ui_down": "Down",
	"ui_left": "Left",
	"ui_right": "Right",
	"dash": "Dash",
	"shoot": "Shoot",
	"grapple": "Grapple",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_action_list()


func create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	for action in input_sections:
		var button = inpt_btn.instantiate()
		var action_label = button.find_child("Label")
		var input_label = button.find_child("InputButton")
		
		action_label.text = input_sections[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text()
		else:
			input_label.text = ""
		action_list.add_child(button)
		
		button.find_child("InputButton").pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	print("remapping")
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Label").text = "Press key..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
func _update_action_list(button, event):
	button.find_child("Label").text = event.as_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(is_remapping)


func save_settings():
	pass
