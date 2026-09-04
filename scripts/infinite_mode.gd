extends Node2D

var rng = RandomNumberGenerator.new()

var rooms: Array[Room] = []

var ROOM_WIDTH := 770
var ROOM_HEIGHT := 730

@export var rooms_counter: int
@export var score: int
@export var room_templates: Array[PackedScene]
@export var player: CharacterBody2D


var pb: int = 0
const SAVE_FILE := "user://save.tres"

var data: PlayerData

var start_room = preload("res://infinite_mod/rooms/start_room.tscn")
var boss1_room = preload("res://infinite_mod/rooms/boss_infinite1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = PlayerData.load_data()
	pb = data.infinite_pb
	$CanvasLayer/Label2.text = "PB : " + str(pb)

	player.add_to_group("player")

	generate_start_room()
	
	for i in range(5):
		generate_roomset()

	var cam = $Camera2D
	remove_child(cam)
	player.add_child(cam)
	
func _process(delta: float) -> void:
	$CanvasLayer/Label.text = "Room " + str(score)

func generate_start_room():
	var start_room_instance = start_room.instantiate() as Room
	start_room_instance.position = Vector2(0, 0)
	rooms.append(start_room_instance)
	add_child(start_room_instance)



func generate_roomset():
	
	var room := room_templates[rng.randi_range(0 ,room_templates.size() - 1)].instantiate() as Room
	
	room.position = Vector2(
		-ROOM_WIDTH * rooms.size(),
		0
	)
	add_child(room)
	rooms.append(room)




	

func _on_character_body_2d_player_dead() -> void:
	if data.update_pb(score):
		pb = data.infinite_pb
	get_tree().reload_current_scene()
	rooms_counter += 1




func load_pb():
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		file.get_as_text()
