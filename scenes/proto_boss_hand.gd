extends RigidBody2D

@onready var player = get_tree().get_first_node_in_group("player")

@onready var camera = get_tree().get_first_node_in_group("camera")

@onready var boss_controller = get_parent().get_node("../demo_boss_controller")

@onready var warning_sprite = load("res://scenes/boss_1_warning.tscn")

var spawn_pos := Vector2.ZERO
var target_pos := Vector2.ZERO

var health = 30

var t := 0.0
var moving := false
var is_attacking := false
@export var is_on_ground := false

var rng = RandomNumberGenerator.new()
var isCure = false

func _ready() -> void:
	if boss_controller.current_phase == boss_controller.Phases.phase1:
		scale.x = 0.03 
		scale.y = 0.03
	elif boss_controller.current_phase == boss_controller.Phases.phase2:
		scale.x = 0.5
		scale.y = 0.5
		$Sprite2D.modulate = Color.RED
	if player != null:
		player = get_tree().get_first_node_in_group("player")
		spawn_pos = Vector2(player.position.x, player.position.y - 50)
		position = spawn_pos
		$Timer.start()
		spawn_warning_sprite()
	boss_controller = get_parent().get_node("../demo_boss_controller")
	var randomInteger = rng.randi_range(1, 5)
	print(randomInteger)
	if randomInteger == 1:
		
		
		isCure = true
	print(str(isCure))
	if isCure:
		$Sprite2D.modulate = Color(0.28, 0.728, 0.0, 1.0)

func _process(delta: float) -> void:
	if health <= 0:
		die()
	
	

		

func _on_timer_timeout() -> void:
	attack(0.5)
	
	
func attack(delta):
	gravity_scale = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	moving = false
	
	if body.is_in_group("player") and isCure == false:
		if boss_controller.current_phase == boss_controller.Phases.phase1:
			body.take_damage(1)
			queue_free()
		elif boss_controller.current_phase == boss_controller.Phases.phase2:
			body.take_damage(2)
			queue_free()
	elif body.is_in_group("player") and isCure == true:
		if body.health < body.max_health:
			body.health += 1
		queue_free()
	if body.is_in_group("tilemap"):
		is_on_ground = true
		add_to_group("enemies")
		$disapear_timer.start()
		camera.start_shake(1)
		
func die():
	queue_free()
	
func take_damage(damage):
	health -= damage
	if boss_controller != null:
		boss_controller.take_damage(1)
		print(boss_controller.health)


func _on_disapear_timer_timeout() -> void:
	queue_free()
	
	
func spawn_warning_sprite():
	var warning_instance = warning_sprite.instantiate()
	warning_instance.global_position = Vector2(spawn_pos.x, 290)
	get_tree().current_scene.add_child(warning_instance)
