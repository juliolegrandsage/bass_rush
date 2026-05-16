extends Area2D

var player_on_ladder := false
var player_ref = null
@export var player_speed_on_going_up = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_on_ladder and player_ref != null:
		if Input.is_action_pressed("use"):
			player_ref.velocity.y = lerp(player_ref.velocity.y, -150.0, player_speed_on_going_up * delta)
			



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_on_ladder = true
		player_ref = body
		print("joueur entré sur l'echelle")




func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_on_ladder = false
		player_ref = null
		body.on_ladder = false
