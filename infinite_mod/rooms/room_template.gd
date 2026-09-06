extends Node2D
class_name Room


var infinite_mode_scene = preload("res://scenes/infinite_mode.tscn")

@export var room_id: int
@export var enemies_account: int

@export var space_cherub_node: CharacterBody2D
@export var oduro_node: CharacterBody2D
var has_player_entered = false
@export var doors_objects: TileMapLayer
func _ready() -> void:
	infinite_mode_scene = get_parent().get_node(".")
	if doors_objects != null:
		doors_objects.add_to_group("tilemap")
func _process(delta: float) -> void:
	count_enemies_in_room()
	if doors_objects != null:
		if enemies_account <= 0:
			open_doors()
func close_doors():
	if doors_objects != null:
		doors_objects.close()
	print(enemies_account)


func open_doors():
	if doors_objects != null:
		doors_objects.open()

func count_enemies_in_room():
	enemies_account = 0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_ancestor_of(enemy):
			enemies_account += 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		infinite_mode_scene.generate_roomset()
		close_doors()
		if enemies_account <= 0:
			infinite_mode_scene.score += 1
			
