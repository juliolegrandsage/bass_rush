extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var boss_controller = $"../demo_boss_controller"
@onready var animation_player = $AnimationPlayer
@onready var transition_to_menu = $"../CanvasLayer2"

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	animation_player.play("RESET")

func _process(delta: float) -> void:
	if boss_controller.is_dead == false:
		position.x = player.position.x
	else:
		launch_death_animation()
		
	
func launch_death_animation():
	animation_player.play("death")
	await get_tree().create_timer(1.0).timeout
	transition_to_menu.get_node("ColorRect/AnimationPlayer").play("fadeout")
