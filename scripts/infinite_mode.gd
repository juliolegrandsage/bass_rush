extends Node2D

var rng = RandomNumberGenerator.new()

var rooms: Array[Room] = []

var ROOM_WIDTH := 770
var ROOM_HEIGHT := 730

@export var room_templates: Array[PackedScene]
@onready var player = $CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for i in range(5):
		generate_roomset()

	var cam = $Camera2D
	remove_child(cam)
	player.add_to_group("player")
	player.add_child(cam)

func generate_roomset():
	
	var room := room_templates[rng.randi_range(0 ,1)].instantiate() as Room
	
	room.position = Vector2(
		-ROOM_WIDTH * rooms.size(),
		0
	)
	add_child(room)
	rooms.append(room)
