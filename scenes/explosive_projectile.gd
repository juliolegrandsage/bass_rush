extends Projectile

@onready var explosion_asset = preload("res://scenes/explosion.tscn")

func _ready() -> void:
	pass

func _physics_process(delta):
	velocity = Vector2(direction * SPEED, 0)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		explode()

func _on_timer_2_timeout() -> void:
	pass


func explode():
		var explosion_instance = explosion_asset.instantiate()
		explosion_instance.position = position
		add_sibling(explosion_instance)
		queue_free()


func _on_eplosion_timer_timeout() -> void:
	explode()
