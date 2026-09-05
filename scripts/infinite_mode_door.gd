extends TileMapLayer

# @onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	collision_enabled = false
	visible = false
func open():
	collision_enabled = false
	visible = false
func close():
	collision_enabled = true
	visible = true
