# A FAIRE : Equilibrer la difficulté


extends CharacterBody2D

var speed = 350
var health = 50
var max_health = 50

var head_down = false

# Réferences aux projectiles du boss

const projectile_reference = preload("res://scenes/boss_3_projectile.tscn")
const web_reference = preload("res://scenes/boss_3_web.tscn")


enum States{
	top,
	bottom,
	descend,
	ascend,
	stop_before_ground
}

var current_state = States.bottom


var just_bounced = false


var descending_stopped = false
var has_hit_ground = false
func _ready() -> void:
	$rope.visible = false

func _process(delta: float) -> void:
	if health <= 0:
		die()

func _physics_process(delta: float) -> void:
	# $"../Label".text = str($attack_timer.is_stopped())
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
			velocity = Vector2(0, 200)
			if $RayCast2D.is_colliding() and not has_hit_ground:
				$"../Label".text = "stop"
				has_hit_ground = true
				call_deferred("set_state", States.stop_before_ground)
				
		States.stop_before_ground:
			velocity = Vector2.ZERO
		States.ascend:
			velocity = Vector2(0, -150)
			rotation_degrees = 180
			if is_on_ceiling():
				set_state(States.top)
			
	move_and_slide()


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
			$"../Label".text = "top"
		States.bottom:
			$rope.visible = false
		States.descend:
			$rope.visible = true
			$attack_timer.stop()
		States.ascend:
			$attack_timer.stop()
		States.stop_before_ground:
			$"../Label".text = "ground"
			$stop_descending_timer.start()
			
			$attack_timer.start()
func _on_top_angle_body_entered(body: Node2D) -> void:
	if body == self:
		set_state(States.top)
		$descending_timer.start()
		$attack_timer.start()


func _on_descending_timer_timeout() -> void:
	descend()
	
func descend():
	if current_state != States.top:
		return
	set_state(States.descend)
	$rope.visible = true


func _on_stop_descending_timer_timeout() -> void:
	$"../Label".text = "ascend"
	set_state(States.ascend)


# Fonctions d'attaques

var rng = RandomNumberGenerator.new()

func attack():
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


func _on_attack_timer_timeout() -> void:
	if current_state == States.stop_before_ground:
		$attack_timer.wait_time = 1
		attack()
		$attack_timer.start()
	if current_state == States.top:
		$attack_timer.wait_time = 0.5
		attack()
		$attack_timer.start()
		
		
# Fonctions de prise de dégats et mort

func take_damage(damage):
	health -= damage

func die():
	queue_free()
