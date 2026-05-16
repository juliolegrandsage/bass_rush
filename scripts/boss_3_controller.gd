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
	left_angle,
	right_angle,
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

var current_state = State.bottom_angle

var distance_to_player: float

func _ready() -> void:
	rope.visible = false

 # A faire : corriger le bug qui fait que le boss ne bouge plus quand il est sur le mur gauche, mettre un randomizer pour aller soit à droite soit à gauche quand le boss est sur le toit
func _physics_process(delta: float) -> void:
	match current_state:
		State.bottom_angle:
			rotation_degrees = 0
		State.top_angle:
			rotation_degrees = 180
			velocity = Vector2(-SPEED, 0)

		State.left_angle:
			rotation_degrees = 90
			velocity = Vector2(0, SPEED)
		State.right_angle:
			rotation_degrees = 270
			velocity = Vector2(0, -SPEED)
		State.descend:
			descend()
		State.ascend:
			ascend()
	
	move_and_slide()
	
func _process(delta: float) -> void:
	$"../Label".text = "velocité du boss : " + str(velocity) + " état actuel " + str(current_state)

func descend():
	rotation_degrees = 180
	velocity = Vector2(0, 100)
	rope.set_point_position(1, to_local(anchor_point))
	if floor_ray.is_colliding():
		velocity = Vector2.ZERO
		
func ascend():
	rotation_degrees = 180
	velocity = Vector2(0, -100)
	rope.set_point_position(1, to_local(anchor_point))
	if global_position.y <= anchor_point.y + 10:
		rope.visible = false
		current_state = State.top_angle

func jump():
	velocity = Vector2(0, -JUMP_FORCE)


func _on_bottom_angle_body_entered(body: Node2D) -> void:
	if body == self and current_state != State.descend and current_state != State.ascend:
		current_state = State.bottom_angle
		jump()
		
func _on_top_angle_body_entered(body: Node2D) -> void:
	if body == self and current_state != State.descend and current_state != State.ascend:		
		if rng.randi_range(0, 1) == 0:
			anchor_point = global_position
			rope.visible = true
			rope.set_point_position(0, Vector2.ZERO)
			current_state = State.descend
			$stop_descending_timer.start()



func _on_right_angle_body_entered(body: Node2D) -> void:
	if body == self and current_state != State.descend and current_state != State.ascend:
		current_state = State.left_angle


func _on_left_angle_body_entered(body: Node2D) -> void:
	if body == self and current_state != State.descend and current_state != State.ascend:		
		current_state = State.right_angle
		
func attack():
	pass


func _on_stop_descending_timer_timeout() -> void:
	current_state = State.ascend	


func set_state(new_state):
	if state_cooldown:
		return
	current_state = new_state
	state_cooldown = true
	await get_tree().create_timer(0.3).timeout
	state_cooldown = false
	
