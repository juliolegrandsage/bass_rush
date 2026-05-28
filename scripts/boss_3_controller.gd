# A FAIRE : Equilibrer la difficulté


extends CharacterBody2D

var speed = 350
var health = 20
var max_health = 80

var head_down = false

# Réferences aux projectiles du boss

const projectile_reference = preload("res://scenes/boss_3_projectile.tscn")
const web_reference = preload("res://scenes/boss_3_web.tscn")

var player_ref: CharacterBody2D

@onready var crosshair = $laser_line/Sprite2D


enum States{
	top,
	bottom,
	descend,
	ascend,
	stop_before_ground,
	transition,
	left_wall,
	right_wall
}

enum Phases{
	phase1,
	phase2
}

var current_state = States.bottom
var current_phase = Phases.phase1

var just_bounced = false

var descending_speed = 200

var descending_stopped = false
var has_hit_ground = false
func _ready() -> void:
	$rope.visible = false
	current_phase = Phases.phase1
	player_ref = get_tree().get_first_node_in_group("player")
	is_laser_active = false
	crosshair.visible = false
func _process(delta: float) -> void:

	if current_phase == Phases.phase2:
		is_laser_active = true
		
	if current_state == States.transition:
		if health < max_health:
			health += 500 * delta
			health = min(health, max_health)

func _physics_process(delta: float) -> void:
	if is_laser_locked:
		rotation_degrees = 180
		velocity = Vector2.ZERO
	$laser_spawn_point.rotation_degrees = 0
	match current_state:
		States.top:
			velocity = Vector2(speed, 0)
			rotation_degrees = 180
			if is_on_wall() and not just_bounced:
				speed *= -1
				just_bounced = true
			elif not is_on_wall():
				just_bounced = false
		States.bottom:
			velocity = Vector2(0, -speed)
			rotation_degrees = 0
		States.descend:
			velocity = Vector2(0, descending_speed)
			if $RayCast2D.is_colliding() and not has_hit_ground:
				has_hit_ground = true
				call_deferred("set_state", States.stop_before_ground)
				
		States.stop_before_ground:
			velocity = Vector2.ZERO
		States.ascend:
			velocity = Vector2(0, -150)
			rotation_degrees = 180
			if is_on_ceiling():
				set_state(States.top)
		States.transition:
			velocity = Vector2.ZERO
			
	move_and_slide()
	
	update_rope()
	if current_phase == Phases.phase1:
		is_laser_active = false
		$laser_line.visible = false
	if current_phase == Phases.phase2:
		$laser_line.visible = true
		update_laser()
	


func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state
	
	if new_state != States.stop_before_ground:
		descending_stopped = false
	
	_on_state_enter(new_state)

func _on_state_enter(state):
	match state:
		States.top:
			has_hit_ground = false
			$rope.visible = false
			$attack_timer.start()
		States.bottom:
			$rope.visible = false
		States.descend:
			$rope.visible = true
			$attack_timer.stop()
		States.ascend:
			$attack_timer.stop()
		States.stop_before_ground:
			if current_phase == Phases.phase1:
				$stop_descending_timer.start()
				$attack_timer.start()
		
			elif current_phase == Phases.phase2:
				is_laser_locked = true
				$"../Label".text = "Phase laser"
		States.transition:
			velocity = Vector2.ZERO
func _on_top_angle_body_entered(body: Node2D) -> void:
	if body == self:
		if not current_state == States.transition:
			set_state(States.top)
			$descending_timer.start()
			$attack_timer.start()


func _on_descending_timer_timeout() -> void:
	if not is_in_transition:
		descend()
	
func descend():
	if current_state != States.top:
		return
	set_state(States.descend)
	$rope.visible = true


func _on_stop_descending_timer_timeout() -> void:
	is_laser_locked = false
	set_state(States.ascend)
func update_rope():
	if not $rope.visible:
		return
	
	if $rope_raycast.is_colliding():
		$rope.points = [
			Vector2.ZERO,
			to_local($rope_raycast.get_collision_point())
		]


# Fonctions d'attaques

var rng = RandomNumberGenerator.new()
func attack():
	if is_in_transition:
		return

	var selector = rng.randi_range(0, 1)
	if selector == 0:
		var projectile_instance = projectile_reference.instantiate()
		projectile_instance.position = $attack_spawn_point.global_position
		add_sibling(projectile_instance)
		selector = rng.randi_range(0, 1)
	elif selector == 1:
		var web_instance = web_reference.instantiate()
		web_instance.position = $attack_spawn_point.global_position
		add_sibling(web_instance)
		selector = rng.randi_range(0, 1)
	await get_tree().create_timer(0.25).timeout

func _on_attack_timer_timeout() -> void:
	if current_state == States.stop_before_ground and current_phase == Phases.phase1:
		$attack_timer.wait_time = 1
		attack()
		$attack_timer.start()
	elif current_state == States.stop_before_ground and current_phase == Phases.phase2:
		$attack_timer.wait_time = 0.45
		attack()
		$attack_timer.start()

		
# Fonctions de prise de dégats et mort

func take_damage(damage):
	health -= damage
	
	if health > 0:
		return
	
	if health <= 0:
		if current_phase == Phases.phase1:
			healing_transition()
			
		else:
			die()

func die():

	queue_free()	


func enter_phase2():
	current_phase = Phases.phase2
	health = max_health
	speed = 420
	descending_speed = 400
	$attack_timer.wait_time = 0.45
	
# FAIT : un état de transitions entre les deux phases ou le boss "vomit" du soin

var is_in_transition := false

func healing_transition():
	is_in_transition = true
	set_state(States.transition)

	$attack_timer.stop()

	for i in range(20):
		var projectile_instance = projectile_reference.instantiate()
		projectile_instance.is_healing = true
		projectile_instance.position = global_position + Vector2(randi_range(-100,100), randi_range(-100,100))
		add_sibling(projectile_instance)

		await get_tree().create_timer(0.2).timeout

	$transition_timer.start(5.0)


func _on_transition_timer_timeout() -> void:
	is_in_transition = false
	enter_phase2()
	
	
# A FAIRE : Mettre un laser qui suit le joueur peu avant l'attaque (avec un timer et une line 2d)

enum laser_states{
	track,
	lock,
	fire,
}

var laser_lenght = 2400
var is_laser_active = false
var is_laser_locked = false

var current_laser_state = laser_states.track
var is_locked := false
func update_laser():
	if player_ref == null:
		return

	var origin = $laser_spawn_point.global_position
	var target = player_ref.global_position

	match current_laser_state:
		laser_states.track:
			crosshair.global_position = target
			crosshair.visible = true
			if not is_locked:
				$laser_spawn_point/laser_timer.start()
				is_locked = true

		laser_states.lock:
			target = saved_position
			crosshair.global_position = target
			crosshair.visible = true
		laser_states.fire:
			target = saved_position
			crosshair.global_position = target
	$laser_line.set_point_position(0, to_local(origin))
	$laser_line.set_point_position(1, to_local(target))

var saved_position = Vector2.ZERO

func save_player_position():
	saved_position = player_ref.global_position  


func _on_laser_timer_timeout() -> void:
	save_player_position()

	current_laser_state = laser_states.lock
	is_locked = true
	$laser_spawn_point/laser_shoot_timer.start()
	
var rocket_ref = preload("res://scenes/boss_3_rocket.tscn")

func _on_laser_shoot_timer_timeout() -> void:
	current_laser_state = laser_states.fire
	var rocket_instance = rocket_ref.instantiate()
	rocket_instance.global_position = $laser_spawn_point.global_position
	rocket_instance.rocket_target = saved_position
	add_sibling(rocket_instance)
	is_locked = false
	crosshair.visible = false
	current_laser_state = laser_states.track
