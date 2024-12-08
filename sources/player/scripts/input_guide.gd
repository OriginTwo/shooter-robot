extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_n") ||\
			Input.is_action_just_pressed("move_e") ||\
			Input.is_action_just_pressed("move_s") ||\
			Input.is_action_just_pressed("move_w") ||\
			Input.is_action_just_pressed("shoot") ||\
			Input.is_action_just_pressed("show_upgrades"):
		queue_free()
