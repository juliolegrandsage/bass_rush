extends Node2D

var save_file = "user://progress.json"

var current_progress = {
	"current_level": ""
}

func load_progress():
	if not FileAccess.file_exists(save_file):
		push_warning("Aucun fichier de sauvegarde trouvé, valeurs par défaut utilisées.")
		return current_progress
	
	var file = FileAccess.open(save_file, FileAccess.READ)
	var json = file.get_as_text()
	file.close()
	
	var save_object = JSON.new()
	var error = save_object.parse(json)
	
	if error == OK and typeof(save_object.data) == TYPE_DICTIONARY:
		current_progress = save_object.data
	else:
		push_warning("Fichier de sauvegarde corrompu ou invalide.")
	
	return current_progress

func save_progress():
	var file = FileAccess.open(save_file, FileAccess.WRITE)
	if file:
		var json_content = JSON.stringify(current_progress, "\t")
		file.store_string(json_content)
		file.close()

func save_current_level():
	current_progress["current_level"] = get_tree().current_scene.scene_file_path
	save_progress()

func load_current_level():
	load_progress()
	var level_path = current_progress.get("current_level", "")
	if level_path != "":
		get_tree().change_scene_to_file(level_path)
	else:
		push_warning("Aucun niveau sauvegardé, lancement du niveau par défaut.")
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
