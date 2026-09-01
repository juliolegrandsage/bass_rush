extends CharacterBody2D


var SPEED = 100.0

var facing_right = false

signal dead

@onready var player = get_tree().get_first_node_in_group("player")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_player_detected:bool
var direction = -1
var health = 5

var projectile_ref = load("res://scenes/oduro_projectile.tscn")

var animator = null
var distance_to_player: float
var can_attack = true
var is_attacking = false
func _ready() -> void:
	animator = $AnimatedSprite2D
	animator.play("walk")

func _process(delta: float) -> void:
	if health <= 0:
		die()
	update_facing()
	if $player_detector.get_collider() != null:
		if $player_detector.get_collider().is_in_group("player"):
			is_player_detected = true
		else:
			is_player_detected = false
	if is_player_detected:
		if global_position.x <= player.global_position.x:
			$AnimatedSprite2D.flip_h = true
		if global_position.x > player.global_position.x:
			$AnimatedSprite2D.flip_h = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = SPEED * direction

	# petit offset de sécurité
	if is_on_floor() and !$RayCast2D.is_colliding():
		flip()
	if is_on_wall():
		flip()
	distance_to_player = player.global_position.distance_to(self.global_position)
	if can_attack:
		if distance_to_player <= 300:
			is_attacking = true
		else:
			is_attacking = false
	if is_attacking:
		velocity.x = 0
		if $attack_timer.is_stopped():
			$attack_timer.start()
	else:
		velocity.x = SPEED * direction
		if not $attack_timer.is_stopped():
			$attack_timer.stop()
	move_and_slide()
func flip():
	direction *= -1

	$AnimatedSprite2D.flip_h = direction > 0

	$RayCast2D.target_position.x = 86 * direction

func take_damage(damage:int):
	get_node("AnimatedSprite2D").modulate = Color.RED
	$Timer.start()
	health -= damage
	
	
func die():
	queue_free()
	emit_signal("dead")
func attack():

	print(can_attack)
	if can_attack:
		var projectile_instance = projectile_ref.instantiate()

		var spawn = $projectile_spawn_point.global_position
		var dir = (player.global_position - spawn).normalized()

		projectile_instance.spawn_pos = spawn
		projectile_instance.spawn_rot = rotation
		projectile_instance.direction = dir

		add_sibling(projectile_instance)
	else:
		return
func _on_attack_timer_timeout() -> void:
	attack()

func update_facing():
	if not player :
		return
	var player_detector_collider = $player_detector.get_collider()
	if global_position.x <= player.global_position.x:
		$player_detector.target_position.x = 900
		$projectile_spawn_point.position.x = 82
		
	elif global_position.x > player.global_position.x:
		$player_detector.target_position.x = -900
		$projectile_spawn_point.position.x = -82

		
	if player_detector_collider and player_detector_collider.is_in_group("player"):
		can_attack = true
	else:
		can_attack = false
		


func _on_timer_timeout() -> void:
	get_node("AnimatedSprite2D").modulate = Color.WHITE
