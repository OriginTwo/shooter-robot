class_name ShakeComponent
extends Node

@export var actor: Node2D
@export_range(0.1, 100.0) var radius: float = 2.0
@export_range(0.1, 100.0) var duration: float = 0.25

var actor_default_position: Vector2
var decay: float
var current_strength: float

func _ready() -> void:
	actor_default_position = actor.position
	decay = 1.0/duration

func _process(delta: float) -> void:
	if current_strength > 0.0:
		actor.position = actor_default_position + radius * Vector2(
			randf_range(-current_strength, current_strength),
			randf_range(-current_strength, current_strength))

	current_strength = max(0.0, current_strength - decay * delta)

func shake(strength: float = 1.0) -> void:
	current_strength = clamp(current_strength + strength, 0.0, 1.0)
