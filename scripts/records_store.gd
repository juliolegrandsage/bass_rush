extends CanvasLayer

@export var disks: Disks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in disks.disks_items:
		create_play_button(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_play_button(disk: DiskSystem):
	var button := Button.new()
	button.text = disk.music_name
	
	$Panel/Control.add_child(button)
	
