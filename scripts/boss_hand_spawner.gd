extends Node2D

@onready var boss_controller = $"../demo_boss_controller"
@export var boss_hand = preload("res://scenes/proto_boss_hand.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

@export var boss_hand_instance_number := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$Timer.start()
	print("apparu")

func _process(delta: float) -> void:
	if boss_controller.current_phase == boss_controller.Phases.phase1:
		$Timer.wait_time = 1
	elif boss_controller.current_phase == boss_controller.Phases.phase2:
		$Timer.wait_time = 0.85

func _on_timer_timeout() -> void:
	var instance = boss_hand.instantiate()
	add_child(instance)
	boss_hand_instance_number += 1
	instance.position = Vector2(player.position.x, player.position.y - 200)
	print(instance.name)
	
