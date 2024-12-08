extends Control

@export var transition_texture: Texture2D

@onready var score_label: Label = %ScoreLabel

func _ready() -> void:
	SceneTransition.set_transition_color(Color8(63, 40, 50))
	SceneTransition.set_transition_texture(transition_texture)

	score_label.text = "%d" % Global.score

func _input(event: InputEvent) -> void:
	if !event is InputEventMouseButton:
		return

	if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		AudioManager.play_sound("blip")
		SceneTransition.transition_first_half()
		await SceneTransition.transitioned_half
		get_tree().change_scene_to_file("res://sources/game/game.tscn")
