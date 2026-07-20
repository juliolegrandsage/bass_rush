extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 1
@export var player: CharacterBody2D

@onready var explosion = preload("res://scenes/explosion.tscn")

var target_pos: Vector2
var can_attack: bool

var has_exploded = false

func _ready() -> void:
	can_attack = false
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:

	if player.global_position.distance_to(global_position) < 200:
		can_attack = true
	
	if can_attack:
		target_pos = (player.global_position - global_position).normalized()
		
		if player != null:
			velocity = target_pos * SPEED
			$AnimationPlayer.play("RESET")
			if player.global_position.distance_to(global_position) <= 70:
				if has_exploded == false:
					has_exploded = true
					$explode_timer.start()

			
	if player != null:
		if global_position.x <= player.global_position.x:
			$AnimatedSprite2D.flip_h = true
		if global_position.x > player.global_position.x:
			$AnimatedSprite2D.flip_h = false
		
	move_and_slide()
	if health <= 0:
		queue_free()
	
func take_damage(damage: int):
	health -= damage


func _on_explode_timer_timeout() -> void:
	var explosion_asset = explosion.instantiate()
	explosion_asset.does_affect_player = true
	explosion_asset.global_position = global_position
	add_sibling(explosion_asset)
	
