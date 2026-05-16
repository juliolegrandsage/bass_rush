# code pour le spawner des plateformes du boss 2 dans le cadre de la démo

extends Node2D


var rng = RandomNumberGenerator.new()

@onready var platform_object = preload("res://scenes/boss_2_projectile.tscn")

var shoot_cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
