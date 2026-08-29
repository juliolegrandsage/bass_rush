extends Node2D
class_name Room


@export var room_id: int
@export var enemies_account: int






func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass
