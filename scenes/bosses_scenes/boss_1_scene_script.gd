extends Node2D

@onready var camera = $Camera2D
@onready var boss_scene = $Sprite2D

@onready var boss_controller = $demo_boss_controller

@onready var player = $Player

@onready var save_handler = $SaveHandler

var is_camera_zoomed_on_boss = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.scale = Vector2(0.7, 0.7)
	save_handler.save_current_level()
func _process(delta: float) -> void:
	pass
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://scenes/projectile.tscn":
		boss_controller.take_damage(10)
		
