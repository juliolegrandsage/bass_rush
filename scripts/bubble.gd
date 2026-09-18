extends Area2D

@export var sister_bubble: Area2D
var can_teleport = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_teleport:
		body.position = sister_bubble.get_node("Destination").global_position
		$AnimationPlayer.play("bounce")
		sister_bubble.get_node("AnimationPlayer").play("bounce")

		sister_bubble.get_node("Timer").start()

func _on_timer_timeout() -> void:
	sister_bubble.can_teleport = true
	
