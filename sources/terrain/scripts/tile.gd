extends Sprite2D

const MAX_DISTANCE: float = 60.0

func _process(delta: float) -> void:
	var dist := global_position.distance_to(get_global_mouse_position())
	if dist <= MAX_DISTANCE:
		var val := 1.0 - (dist / MAX_DISTANCE)
		val = 1.0 - pow(2.0, -10.0 * val)
		scale = Vector2(val, val)
	else:
		scale = Vector2.ZERO
