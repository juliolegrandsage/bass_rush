extends CanvasLayer

@export var dialogue = "Test message"
@onready var label = $NinePatchRect/Label
@export var voice = null

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	label.text = dialogue	

func show_dialogue() -> void:
	visible = true
	$AnimationPlayer.play("open_dialogue")
	print("dialogue")

func quit_dialogue():
	Engine.time_scale = 1
	$AnimationPlayer.play("clos_dialogue")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "open_dialogue"):
		Engine.time_scale = 0
