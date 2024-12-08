extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)

func on_animation_finished(_anim_name: StringName) -> void:
	SignalBus.game_over_animation_finished.emit()
	queue_free()
