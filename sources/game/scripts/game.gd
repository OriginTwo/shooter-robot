extends Node2D

@onready var player: Player = $Player

var camera: Camera2D

func _ready() -> void:
	SignalBus.game_over.connect(on_game_over)
	SignalBus.game_over_animation_finished.connect(on_game_over_animation_finished)

	VfxUtil.config_game_camera(3.0, 0.3)

	set_deferred("camera", get_tree().get_first_node_in_group("game_camera"))

func on_game_over() -> void:
	camera.reparent(self)

func on_game_over_animation_finished() -> void:
	print("transition to game over scene")
