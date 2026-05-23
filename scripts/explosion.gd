extends Area2D

@export var does_affect_player = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CPUParticles2D.emitting = true
	await get_tree().create_timer($CPUParticles2D.lifetime).timeout
	queue_free()
	print("boum boum")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and !body.is_in_group("boss_controller"):
		body.take_damage(50)
	if does_affect_player and body.is_in_group("player"):
		body.take_damage(2)
