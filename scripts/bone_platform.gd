extends Sprite2D

var is_broken = false
var is_timer_enabled = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_broken:
		$".".region_rect = Rect2(16, 0, 16, 16)
		if is_timer_enabled == false:
			is_timer_enabled = true
			$BreakTimer.start()


func _on_break_timer_timeout() -> void:
	$StaticBody2D/CollisionShape2D.disabled = true
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_broken = true
