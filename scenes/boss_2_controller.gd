extends CharacterBody2D

@export var top_position_max : float
@export var bottom_position_max : float

@onready var platform_object = preload("res://scenes/boss_2_projectile.tscn")

@export var speed : float = 1
var time := 0.0

var can_attack = false

## STATS DU BOSS
var health = 20

var max_health = 20

enum phases{
	phase1,
	phase2
}
var current_phase = phases.phase1

func _ready() -> void:
	position = Vector2(position.x, bottom_position_max)
	$AnimationPlayer.play("boss2_open_mouth")
	$Timer.start()
	
func _physics_process(delta: float) -> void:
	time += delta * speed
	var range = (bottom_position_max - top_position_max) / 2
	var center = (bottom_position_max + top_position_max) / 2
	position.y = center + sin(time) * range

	
func _process(delta: float) -> void:
	if health <= 0 and current_phase == phases.phase1:
		current_phase = phases.phase2
		health = 30
		$Timer.wait_time = 0.85
		$AnimationPlayer.speed_scale = 3
	elif health <= 0 and current_phase == phases.phase2:
		die()

func take_damage(damage):
	if can_attack:	
		health -= damage
		$Face_top.modulate = Color.RED
		$Face_bottom.modulate = Color.RED
		$damage_indicator_timer.start()
	
func die():
	get_tree().quit()

func attack():
	if can_attack:
		var platform_instance = platform_object.instantiate()
		platform_instance.scale = Vector2(0.5, 0.5)
		platform_instance.position = $ProjectileSpawnPoint.global_position
		add_sibling(platform_instance)




func set_can_attack_true():
	can_attack = true
	attack()
	print(can_attack)
func set_can_attack_false():
	can_attack = false
	print(can_attack)
	
# ce timer ne dure qu'une seconde
func _on_timer_timeout() -> void:
	attack()


# celui ci dure 5 seconde
func _on_atttack_repeater_timeout() -> void:
	$AnimationPlayer.play("boss2_open_mouth")
	$Timer.start()



func _on_damage_indicator_timer_timeout() -> void:
	$Face_top.modulate = Color.WHITE
	
	$Face_bottom.modulate = Color.WHITE
