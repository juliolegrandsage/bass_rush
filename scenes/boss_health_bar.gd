extends ProgressBar

@export var boss_controller: Node2D


func _ready():
	max_value = 100

func _process(delta: float) -> void:
	if boss_controller != null:
		value = boss_controller.health * 100.0 / boss_controller.max_health
