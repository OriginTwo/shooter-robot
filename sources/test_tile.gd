extends Sprite2D

var target_pos: float
var is_animating: bool

func _ready() -> void:
	target_pos = offset.y
	offset.y = target_pos + get_viewport_rect().size.y

func _input(event: InputEvent) -> void:
	if !event is InputEventMouseMotion || is_animating:
		return

	var e := event as InputEventMouseMotion
	const RADIUS := 60.0
	if position.distance_squared_to(e.position) < RADIUS * RADIUS:
		is_animating = true
		var tween := create_tween()
		tween.tween_property(self, "offset:y", target_pos, 1.5)\
			.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
