extends Node2D

@export var transition_texture: Texture2D

@onready var player: Player = $Player

var camera: Camera2D
var game_time: float

func _ready() -> void:
	randomize()

	AudioManager.play_music()

	SceneTransition.transition_rect.visible = true
	SceneTransition.set_transition_color(Color8(63, 40, 50))
	SceneTransition.set_transition_texture(transition_texture)
	SceneTransition.transition_second_half()

	SignalBus.game_over.connect(on_game_over)
	SignalBus.game_over_animation_finished.connect(on_game_over_animation_finished)

	VfxUtil.config_game_camera(3.0, 0.3)

	set_deferred("camera", get_tree().get_first_node_in_group("game_camera"))

	Global.score = 0

func _process(delta: float) -> void:
	game_time += delta

func on_game_over() -> void:
	AudioManager.tween_music_pitch(0.5, 5.0)
	set_process(false)
	camera.reparent(self)
	Global.score = int(game_time)

func on_game_over_animation_finished() -> void:
	SceneTransition.transition_first_half()
	await SceneTransition.transitioned_half
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://sources/game/game_over.tscn")
	SceneTransition.transition_rect.visible = false
