extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var projectile = preload("res://scenes/projectile.tscn")
@onready var projectile_spawn_point = $ProjectileSpawnPoint
@onready var projectile_spawn_point_crouched = $ProjectileSpawnPoint_crouched
@onready var hp_bar = $"../CanvasLayer/Control/Label2"
@onready var collider = $CollisionShape2D
@onready var anim_player = $"AnimationPlayer"
@onready var particle_emitter = $GPUParticles2D
var config_save_file = "user://save.cfg"

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
var jumping = false

@export var is_interacting = false

var is_crouched = false
var dash_up_counter = 0
func _ready() -> void:
	if sprite.flip_h == true:
		projectile_spawn_point.position.x = -40
	elif sprite.flip_h == false:
		projectile_spawn_point.position.x = 40
	collision_mask = 1
func _process(delta: float) -> void:
	if health <= 0:
		die()
	
	if Input.is_action_just_pressed("dash") and !is_on_floor():
		dashing = true
		$DashTimer.start()
		particle_emitter.emitting = true
		if particle_emitter.emitting == true:
			sprite.visible = false
		elif particle_emitter.emitting == false:
			sprite.visible = true
			

	
		# Character crouch system
	
	if !is_interacting:
		if Input.is_action_pressed("ui_down"):
			is_crouched = true
		elif Input.is_action_just_released("ui_down"):
			is_crouched = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or gc.launched or $CoyoteTimeTimer.is_stopped() == false):
		velocity.y += JUMP_VELOCITY
		gc.retract()

			
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	if dashing and velocity.x == 0 and dash_up_counter == 0:
		velocity.y = -DASH_SPEED / 2
		dash_up_counter += 1	
	
	if is_on_floor() and dash_up_counter != 0:
		dash_up_counter = 0		
	if !is_paralyzed:
		move_and_slide()


	
	# Flip the character's sprite when it turns left
	if !is_interacting and not is_crouched:
		if velocity.x < 0:
			sprite.flip_h = true
			projectile_spawn_point.position.x = -40
			projectile_spawn_point_crouched.position.x = -40
			sprite.animation = "walk"
		elif velocity.x > 0:
			sprite.flip_h = false
			projectile_spawn_point.position.x = 40
			projectile_spawn_point_crouched.position.x = 40
			sprite.animation = "walk"
		elif velocity.y != 0:
			sprite.animation = "jump"
		else: 
			sprite.animation = "idle"
		sprite.play()
	# play crouch animations
	if is_crouched and velocity.x == 0:
		sprite.play("crouch_idle")
	elif is_crouched and velocity.x != 0:
		sprite.play("crouch_walk")
		if velocity.x < 0:
			sprite.flip_h = true
			projectile_spawn_point_crouched.position.x = -40
		elif velocity.x > 0:
			sprite.flip_h = false
			projectile_spawn_point_crouched.position.x = 40

	
	# change collision shape scale on the Y axis when crouched
	if is_crouched:
		collider.scale.y = 0.5
		collider.position.y = 15
	else:
		collider.scale.y = 1
		collider.position.y = 0

	if Input.is_action_just_pressed("shoot"):
		if !is_interacting:
			shoot()
	

func shoot():
	var bullet = projectile.instantiate()
	if is_crouched == false:
		bullet.global_position = projectile_spawn_point.global_position
		if $AnimatedSprite2D.flip_h == true:
			bullet.direction = -1
			bullet.get_node("Sprite2D").flip_h = false
		elif $AnimatedSprite2D.flip_h == false:
			bullet.direction = 1
			bullet.get_node("Sprite2D").flip_h = true
	if is_crouched == true:
		bullet.global_position = projectile_spawn_point_crouched.global_position
		if $AnimatedSprite2D.flip_h == true:
			bullet.direction = -1
			bullet.get_node("Sprite2D").flip_h = false
		elif $AnimatedSprite2D.flip_h == false:
			bullet.direction = 1
			bullet.get_node("Sprite2D").flip_h = true

	
	get_parent().add_child(bullet)
	
func die():
	get_tree().reload_current_scene()
	
func take_damage(damage):
	health -= damage
	velocity.y = -150
	


func _on_dash_timer_timeout() -> void:
	dashing = false
	sprite.visible = true
	particle_emitter.emitting = false
func _on_boss_switch_phase() -> void:
	health = max_health

func take_boss_3_web_attack():
	is_paralyzed = true
	$paralysis_timer.start()

func _on_paralysis_timer_timeout() -> void:
	is_paralyzed = false
	
