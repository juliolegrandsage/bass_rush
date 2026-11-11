extends Node2D

class_name NPC

@export var npc_name: String
@export var npc_dialog: Label
@export var text = ""
@export var sprite: AnimatedSprite2D

@export var player: CharacterBody2D

var can_interact = false

func _ready() -> void:
	sprite = $AnimatedSprite2D
	npc_dialog = $AnimatedSprite2D/Label
	npc_dialog.visible = false
func _process(delta: float) -> void:
	if can_interact:
		npc_dialog.visible = true
	else:
		npc_dialog.visible = false
	
	if can_interact and Input.is_action_just_pressed("shoot"):
		npc_dialog.text = text
	
	print(can_interact)
	
	if player:
		if global_position.x < player.global_position.x:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = false
