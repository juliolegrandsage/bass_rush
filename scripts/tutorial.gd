extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/tutorial_card.label_text = "Welcome to bass rush (prototype)"
	$CanvasLayer/tutorial_card.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $CanvasLayer/tutorial_card.visible == true:
		Engine.time_scale = 0
	elif $CanvasLayer/tutorial_card.visible == false:
		Engine.time_scale = 1


func _on_grappin_panel_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$CanvasLayer/tutorial_card.label_text = "Appuyez sur RT pour lancer le grappin"
		$CanvasLayer/tutorial_card.visible = true


func _on_dash_panel_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$CanvasLayer/tutorial_card.label_text = "Appuyez sur LT pour effectuer une ruée"
		$CanvasLayer/tutorial_card.visible = true
