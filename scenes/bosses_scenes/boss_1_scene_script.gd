extends Node2D

@onready var camera = $Camera2D
@onready var boss_scene = $Sprite2D

@onready var boss_controller = $demo_boss_controller

var is_camera_zoomed_on_boss = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss_controller.health <= 0 and boss_controller.is_dead:
		if !is_camera_zoomed_on_boss:
			zoom_to_boss()
func zoom_to_boss():
	$".".remove_child(camera)
	boss_scene.add_child(camera)
	camera.position = Vector2(0, 0)
	camera.zoom *= 2
	is_camera_zoomed_on_boss = true
