extends Node2D

var camera: Camera2D

func _ready() -> void:
	SignalBus.game_over.connect(on_game_over)

	VfxUtil.config_game_camera(3.0, 0.3)

	set_deferred("camera", get_tree().get_first_node_in_group("game_camera"))

func on_game_over() -> void:
	camera.reparent(self)
