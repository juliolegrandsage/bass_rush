extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var projectile = preload("res://scenes/projectile.tscn")
@onready var projectile_spawn_point = $ProjectileSpawnPoint
@onready var hp_bar = $"../CanvasLayer/Control/Label2"

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

const GRAPPLE_ACCELERATION = 0.1

@export var is_paralyzed = false

@export var health = 20
var max_health = 20

var on_ladder := false

@onready var gc := $GrappleController

const DASH_SPEED = 900
var dashing = false

func _ready() -> void:
	if sprite.flip_h == true:
		projectile_spawn_point.position.x = -40
	elif sprite.flip_h == false:
		projectile_spawn_point.position.x = 40



func _process(delta: float) -> void:
	if health <= 0:
		die()
	

	if Input.is_action_just_pressed("dash") and is_on_floor() == false:
		dashing = true
		$DashTimer.start()

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or gc.launched):
		velocity.y += JUMP_VELOCITY
		gc.retract()
			# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if !is_paralyzed:
		move_and_slide()


	
	# Flip the character's sprite when it turns left
	if velocity.x < 0:
		sprite.flip_h = true
		projectile_spawn_point.position.x = -40
		sprite.animation = "walk"
	elif velocity.x > 0:
		sprite.flip_h = false
		projectile_spawn_point.position.x = 40
		sprite.animation = "walk"
	else: 
		sprite.animation = "idle"


	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func shoot():
	var bullet = projectile.instantiate()
	
	bullet.global_position = projectile_spawn_point.global_position
	if $AnimatedSprite2D.flip_h == true:
		bullet.direction = -1
		bullet.get_node("Sprite2D").flip_h = false
	elif $AnimatedSprite2D.flip_h == false:
		bullet.direction = 1
		bullet.get_node("Sprite2D").flip_h = true

	
	get_parent().add_child(bullet)
	
func die():
	print("joueur mort")
	get_tree().reload_current_scene()
	
func take_damage(damage):
	health -= damage
	
	


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_boss_switch_phase() -> void:
	health = max_health

func take_boss_3_web_attack():
	is_paralyzed = true
	$paralysis_timer.start()

func _on_paralysis_timer_timeout() -> void:
	is_paralyzed = false
