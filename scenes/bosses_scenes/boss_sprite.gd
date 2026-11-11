extends AnimatedSprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var boss_controller = $"../demo_boss_controller"
@onready var animation_player = $AnimationPlayer
@onready var transition_to_menu = $"../CanvasLayer2"

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if boss_controller.is_dead == false:
		position.x = player.position.x + 5

		
	
