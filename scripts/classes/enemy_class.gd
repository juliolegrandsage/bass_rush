extends CharacterBody2D

class_name Enemy

@export var speed = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = 1
var start_pos: Vector2
@export var move_distance = 100
@export var health = 20
@export var strenght = 2
@export var use_gravity = true

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	start_pos = position

func take_damage(damage: int):
	health -= damage

func _physics_process(delta: float) -> void:
	if use_gravity:
		if not is_on_floor():
			velocity.y += gravity * delta
	 
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
