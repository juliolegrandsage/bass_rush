extends Area2D

var health_bonus = 30

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bonus = rng.randi_range(1, 5)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health += health_bonus
		print(body.health)
		queue_free()
