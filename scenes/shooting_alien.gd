extends Enemy

var is_shooting = false
@export var projectile_scene = preload("res://enemy_projectile.tscn")


func handle_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func patrol():
	velocity.x = speed * dir

func reverse_dir():
	if is_on_wall():
		dir = -dir

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	if not is_shooting:
		patrol()
		reverse_dir()
	move_and_slide()
	var distance_between_player = global_position.distance_to(player.global_position)
	if distance_between_player <= 100:
		face_player()
		shoot_projectile()
		
func shoot_projectile():
	if not is_shooting:
		is_shooting = true
		velocity.x = 0
		$Timer.start()
		print("piou piou")
		var bullet = projectile_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = dir
		get_tree().current_scene.add_child(bullet)


func face_player():
	if player.global_position.x > global_position.x:
		dir = 1
		$AnimatedSprite2D.flip_h = false
	else:
		dir =-1
		$AnimatedSprite2D.flip_h = true

func _on_timer_timeout() -> void:
	is_shooting = false
