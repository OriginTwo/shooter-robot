extends Node

var camera: Camera2D
var camera_shake_radius: float = 2.0
var camera_shake_strength: float
var camera_shake_decay: float

func config_game_camera(radius: float, duration: float) -> void:
	camera_shake_radius = radius
	camera_shake_decay = 1.0 / duration

func shake_camera(strength: float = 1.0) -> void:
	camera = get_tree().get_first_node_in_group("game_camera")
	camera_shake_strength = clamp(camera_shake_strength + strength, 0.0, 1.0)


func _process(delta: float) -> void:
	if camera_shake_strength > 0.0:
		camera.offset = camera_shake_radius * Vector2(
			randf_range(-camera_shake_strength, camera_shake_strength),
			randf_range(-camera_shake_strength, camera_shake_strength))

	camera_shake_strength = max(0.0, camera_shake_strength - camera_shake_decay * delta)
