@tool
extends EditorPlugin

var dock: Control
var message_input: LineEdit
var commit_button: Button
var project_path: String

func _enter_tree() -> void:
	project_path = ProjectSettings.globalize_path("res://")

	# --- UI ROOT ---
	dock = VBoxContainer.new()
	dock.name = "Git Dock"

	# --- INPUT ---
	message_input = LineEdit.new()
	message_input.placeholder_text = "Commit message..."

	# --- BUTTON ---
	commit_button = Button.new()
	commit_button.text = "Commit"
	commit_button.pressed.connect(_on_commit_pressed)

	# --- ASSEMBLY ---
	dock.add_child(message_input)
	dock.add_child(commit_button)

	# --- ADD TO EDITOR ---
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)

func _exit_tree() -> void:
	if dock:
		remove_control_from_docks(dock)
		dock.queue_free()

func _on_commit_pressed() -> void:
	var message = message_input.text.strip_edges()

	if message == "":
		message = "WIP commit from Godot"

	OS.execute("git", ["-C", project_path, "add", "."], [])
	OS.execute("git", ["-C", project_path, "commit", "-m", message], [])
