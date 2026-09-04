extends TileMapLayer

@onready var player
var is_swimming = false
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("CharacterBody2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_swimming:
		player.SPEED = 100
	if !is_swimming:
		player.SPEED = 200

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if is_swimming == false:
			is_swimming = true
		else:
			is_swimming = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_swimming = false
