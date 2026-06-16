extends CharacterBody2D

@export var speed = 200.0

var direction: Vector2 = Vector2.ZERO

@export var spawn_pos: Vector2
@export var spawn_rot: float

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#body.take_damage(3)
		queue_free()
