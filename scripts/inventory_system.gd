extends Node

@export var items : Array[Item] = []
const ITEM_CLASS = preload("res://scripts/inventory_item.gd")


var item_index = 0
# Called when the node enters the scene tree for the first time.

func add_item(item):
	items.append(item)
	
func next_item():
	item_index = (item_index + 1) % items.size()

func previous_item():
	item_index = (item_index - 1) % items.size()

func _ready() -> void:
	update_ui()

func update_ui():
	var slots= [
		$CanvasLayer/Control/item_icon1,
		$CanvasLayer/Control/item_icon2,
		$CanvasLayer/Control/item_icon3,
		$CanvasLayer/Control/item_icon4,
		]
		
	for i in range(slots.size()):
		if i < items.size() and items[i].item_sprite != null:
			slots[i].texture = items[i].item_sprite
