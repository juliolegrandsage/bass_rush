extends RayCast2D

@export var player = null
@export var projectile = preload("res://enemy_projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		print("joueur trouvé")


func _on_shoot_cooldown_timeout() -> void:
	if player != null:
		target_position = player.position
		$shoot_cooldown.start()
		if is_colliding() and get_collider() == player:
			print(get_collider().name)
			shoot()
			$shoot_cooldown.start()
		else:
			$shoot_cooldown.start()

func shoot():
	var bullet = projectile.instantiate()
	bullet.global_position = global_position
	if player.global_position < $"..".global_position:
		bullet.direction = -1
	else:
		bullet.direction = 1
	get_tree().current_scene.add_child(bullet)
