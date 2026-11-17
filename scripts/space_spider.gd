extends CharacterBody2D

@onready var line_spawn_point = $LineSpawnPoint
var speed = 500
@export var movement_height: float = 16.29
var player: CharacterBody2D
@onready var rope = $Line2D
var is_going_downward = false
var origin : Vector2

var health = 1

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	origin = global_position
func _process(delta: float) -> void:
	
	if player.position.distance_to(position) < 150:
		is_going_downward = true
	else:
		is_going_downward = false
		
	if is_going_downward:
		
		velocity = Vector2(0, movement_height) * speed * delta

		
			
	
	else:
		velocity = Vector2.ZERO
	if $RayCast2D.is_colliding() == false:
		move_and_slide()

	if health <= 0:
		die()
	health = 1
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.take_damage(3)

func take_damage(damage: int):
	health -= damage

func die():
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
