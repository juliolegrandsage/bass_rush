extends Resource
class_name PlayerData

const saver_file = "user://save.tres"
var scene_to_save: PackedScene


@export var infinite_pb: int = 0

func update_pb(new_score: int) -> bool:
	if new_score > infinite_pb:
		infinite_pb = new_score
		save()
		return true
	return false


func save():
	var err := ResourceSaver.save(self, saver_file)
	if err != OK:
		push_error("Sauvagarde foireuse")



static func load_data() -> PlayerData:
	if ResourceLoader.exists(saver_file):
		var loaded = ResourceLoader.load(saver_file)
		if loaded is PlayerData:
			return loaded
	return PlayerData.new()
	
	
