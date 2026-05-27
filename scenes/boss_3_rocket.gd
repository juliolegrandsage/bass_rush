extends RigidBody2D

@onready var player_ref = get_tree().get_first_node_in_group("player")

var explosion_asset = preload("res://scenes/explosion.tscn")

var target_position := Vector2.ZERO
var dir = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_ref != null:
		dir = (player_ref.global_position - global_position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if player_ref:
		linear_velocity = dir * 500
	
	rotation = dir.angle()

func summon_explosion():
	var explosion_instance = explosion_asset.instantiate()
	explosion_instance.global_position = global_position	
	explosion_instance.does_affect_player = true
	add_sibling(explosion_instance)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		summon_explosion()
		queue_free()
	elif body.is_in_group("tilemap"):
		summon_explosion()
		queue_free()


func _on_explode_timeout() -> void:
	summon_explosion()
	queue_free()
