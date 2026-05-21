# script du projectile du boss 3


extends RigidBody2D

var player_scene : CharacterBody2D

var player_position: Vector2

@export var speed = 650

const explosion_scene = preload("res://scenes/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_scene = get_tree().get_first_node_in_group("player")
	player_position = player_scene.position
	gravity_scale = 1
	if player_scene != null:
		var direction = (player_position - global_position).normalized()
		linear_velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		player_scene.take_damage(1)
		var explosion_instance = explosion_scene.instantiate()
		explosion_instance.does_affect_player = true
		explosion_instance.position = global_position
		add_sibling(explosion_instance)
		queue_free()
	elif body.is_in_group("tilemap"):
		var explosion_instance = explosion_scene.instantiate()
		explosion_instance.does_affect_player = true
		explosion_instance.position = global_position
		add_sibling(explosion_instance)
		queue_free()
