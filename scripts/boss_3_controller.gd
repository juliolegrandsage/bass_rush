# commentaire de test


extends CharacterBody2D


const SPEED = 400.0
const JUMP_FORCE = 650

var is_walking = true
var has_attacked = false


var health = 30
var max_health = 30

var state_cooldown = false


@onready var rope = $rope

@onready var floor_ray = $RayCast2D

var is_descending = false
var is_ascending = false
var anchor_point: Vector2

var is_changing_state

var can_proximity_attack = true

enum State{
	top_angle,
	bottom_angle,
	descend,
	ascend
}

enum Attacks{
	shot_web,
	shot_projectile
}



const projectile = preload("res://scenes/boss_3_projectile.tscn")
const web_attack = preload("res://scenes/boss_3_web.tscn")

@onready var player_scene = get_tree().get_first_node_in_group("player")

var rng = RandomNumberGenerator.new()
var top_direction =  rng.randi_range(0, 1) * 2 - 1
var current_state = State.bottom_angle

var distance_to_player: float
var attack_state

func _ready() -> void:
	rope.visible = false
	jump()


 # A faire : corriger le bug qui fait que le boss ne bouge plus quand il est sur le mur gauche, mettre un randomizer pour aller soit à droite soit à gauche quand le boss est sur le toit
func _physics_process(delta):
	match current_state:
		State.bottom_angle:
			rotation_degrees = 0

		State.top_angle:
			rotation_degrees = 180
			velocity = Vector2(SPEED * top_direction, 0)



		State.descend:
			descend()

		State.ascend:
			if current_state == State.ascend:
				ascend()

	move_and_slide()
	

		
	if is_on_wall() and current_state == State.top_angle:
		top_direction *= -1
		velocity.x = SPEED * top_direction

	
func _process(delta: float) -> void:
	$"../Label".text = str(current_state)

func descend():
	rotation_degrees = 180
	velocity = Vector2(0, 100)
	rope.set_point_position(1, to_local(anchor_point))
	if floor_ray.is_colliding():
		velocity = Vector2.ZERO
		
func ascend():
	if current_state != State.ascend:
		return
	rotation_degrees = 180
	velocity = Vector2(0, -100)
	rope.set_point_position(1, to_local(anchor_point))
	if $stop_ascending_timer.is_stopped():
		$stop_ascending_timer.start()

func jump():
	$"../Label".text = "jump"
	velocity.y = -JUMP_FORCE



func _on_bottom_angle_body_entered(body: Node2D) -> void:
	set_state(State.bottom_angle)

		
func _on_top_angle_body_entered(body: Node2D) -> void:
	if body == self and current_state != State.descend and current_state != State.ascend:		
		if rng.randi_range(0, 1) == 0:
			anchor_point = global_position
			rope.visible = true
			rope.set_point_position(0, Vector2.ZERO)
			set_state(State.descend)
			$stop_descending_timer.start()
		else:
			set_state(State.top_angle)
			$descending_timer.start()



func set_state(new_state):
	if new_state == current_state:
		return
		
	$descending_timer.stop()
	$stop_descending_timer.stop()
	$stop_ascending_timer.stop()
	
	var old_state = current_state
	current_state = new_state
	on_state_changed(old_state, new_state)
	
		

func on_state_changed(old_state, new_state):
	match new_state:

		State.descend:
			anchor_point = global_position
			rope.visible = true
			rope.set_point_position(0, Vector2.ZERO)
			$stop_descending_timer.start()
		State.ascend:
			if $stop_ascending_timer.is_stopped():
				$stop_ascending_timer.start()
		
		State.bottom_angle:
			$"../Label".text = "borttom angle"
			jump()

	if new_state == State.top_angle:
		top_direction = rng.randi_range(0, 1) * 2 - 1
		$descending_timer.start()
		




		
func attack():
	var attack_state
	var random_num = rng.randi_range(0, 1)
	if random_num == 0:
		attack_state = Attacks.shot_projectile
	if random_num == 1:
		attack_state = Attacks.shot_web


func _on_stop_descending_timer_timeout() -> void:
	set_state(State.ascend)



func _on_stop_ascending_timer_timeout() -> void:
	$"../Label".text = "timer lancé"
	rope.visible = false
	top_direction = 1
	set_state(State.top_angle)


func _on_descending_timer_timeout() -> void:
	if current_state != State.top_angle:
		return
		
	set_state(State.descend)


func _on_restart_timer_timeout() -> void:
	if attack_state == Attacks.shot_projectile:
		var projectile_instance = projectile.instantiate()
		projectile_instance.position = $attack_spawn_point.global_position
		add_sibling(projectile_instance)
