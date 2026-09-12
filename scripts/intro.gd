extends Node2D

@export var messages: Array[String] = []
@export var letter_delay: float = 0.05
@export var label: Label

var current_message: int
var is_typing = false

var skip_requested: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Settings.load_audio_settings()
	show_message(current_message)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(index: int):
	current_message = index
	await show_characters()

func show_characters():
	is_typing = true
	skip_requested = false
	label.text = ""
	for letter in messages[current_message]:
		if skip_requested:
			label.text = messages[current_message]
			break
		label.text += letter
		await get_tree().create_timer(letter_delay).timeout
	is_typing = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_requested = true
		else:
			current_message += 1
			if current_message < messages.size():
				show_message(current_message)
			if current_message == messages.size():
				$CanvasLayer/Control/ColorRect/Control/Sprite2D.visible = true
				$CanvasLayer/Control/ColorRect/Label.text = ""
				$AnimationPlayer.play("show_logo")
				


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show_logo":
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
