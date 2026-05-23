# script du projectile du boss 3


extends RigidBody2D

var player_scene : CharacterBody2D

var player_position: Vector2

@export var speed = 400

var rng = RandomNumberGenerator.new()
var is_healing = false

var explosion_scene = preload("res://scenes/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_scene = get_tree().get_first_node_in_group("player")
	player_position = player_scene.position
	gravity_scale = 0
	if player_scene != null:
		var direction = (player_position - global_position).normalized()
		linear_velocity = direction * speed
		
	var health_selector = rng.randi_range(0, 2 )
		
	if health_selector == 0:
		is_healing = true
		$Sprite2D.modulate = Color.GREEN
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		if !is_healing:
			var explosion_instance = explosion_scene.instantiate()
			explosion_instance.does_affect_player = true
			get_tree().current_scene.add_child(explosion_instance)
			explosion_instance.global_position = global_position
		elif is_healing:
			player_scene.health = min(player_scene.health + 5, player_scene.max_health)		
		queue_free()
	elif body.is_in_group("tilemap"):
		if !is_healing:
			var explosion_instance = explosion_scene.instantiate()
			explosion_instance.does_affect_player = true
			get_tree().current_scene.add_child(explosion_instance)
			explosion_instance.global_position = global_position
		queue_free()
