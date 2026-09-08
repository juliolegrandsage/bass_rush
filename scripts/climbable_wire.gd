extends Node2D

var player : CharacterBody2D

var can_climb = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_climb and Input.is_action_pressed("ui_up"):
		climb()

func climb():
	pass
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_climb = true
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_climb = false
