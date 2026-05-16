# script du projectile du boss 3


extends RigidBody2D

var player_scene : CharacterBody2D

var player_position: Vector2

@export var speed = 550



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
		player_scene.take_damage(2)
		player_scene.take_boss_3_web_attack()
		queue_free()
	elif body.is_in_group("tilemap"):
		queue_free()


func _on_player_paralisis_timeout() -> void:
	print("joueur paralysé")
