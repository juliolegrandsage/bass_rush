# script du boss de demo

extends Node2D

@export var health = 30
@export var max_health := 30

@export var current_phase = Phases.phase1

enum Phases{
	phase1,
	phase2
}

signal switch_phase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0 and current_phase == Phases.phase1:
		current_phase = Phases.phase2
		switch_phase.emit()
		health = 30
	if health <= 0 and current_phase == Phases.phase2:
		get_tree().quit()



func take_damage(damage):
	health -= damage
