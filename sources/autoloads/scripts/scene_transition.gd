extends CanvasLayer

signal transitioned_half
signal transitioned_full

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var transition_rect: ColorRect = $TransitionRect

enum TransitionType {
	NORMAL,
	WIPE,
}

func transition(path: String, type: TransitionType = TransitionType.NORMAL) -> void:
	transition_rect.material.set_shader_parameter("reverse", false)
	transition_first_half()
	await transitioned_half
	get_tree().change_scene_to_file(path)
	if type == TransitionType.WIPE:
		transition_rect.material.set_shader_parameter("reverse", true)
	transition_second_half()

func set_transition_texture(texture: Texture2D) -> void:
	transition_rect.material.set_shader_parameter("tex", texture)

func set_transition_color(color: Color) -> void:
	transition_rect.material.set_shader_parameter("color", color)

func set_duration(duration: float) -> void:
	animation_player.speed_scale = 1.0 / duration


func transition_first_half() -> void:
	transition_rect.visible = true
	animation_player.play("transition_half")
	await animation_player.animation_finished
	transitioned_half.emit()

func transition_second_half() -> void:
	animation_player.play_backwards("transition_half")
	await animation_player.animation_finished
	transitioned_full.emit()
	transition_rect.visible = false
