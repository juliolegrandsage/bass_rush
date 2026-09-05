extends Area2D

@export var life_add = 3
@export var is_mega_heart= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_mega_heart:
		$AnimatedSprite2D.modulate = Color.YELLOW
		life_add = 20
	else:
		life_add = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if PlayerStats.player_hp < body.max_health:
			PlayerStats.player_hp += life_add
			clamp(PlayerStats.player_hp, 0, 20)
			queue_free()
