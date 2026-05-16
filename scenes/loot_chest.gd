extends StaticBody2D


@export var health := 5

@export var loot = preload("res://scenes/health_giver.tscn")

func _ready() -> void:
	add_to_group("enemies")

func take_damage(damage):
	health -= damage
	
func _process(delta: float) -> void:
	if health <= 0:
		instatiate_loot()
		queue_free()

func instatiate_loot():
	var bonus = loot.instantiate()
	add_sibling(bonus)
	bonus.position = position
