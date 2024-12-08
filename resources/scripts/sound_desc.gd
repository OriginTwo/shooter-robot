class_name SoundDesc
extends Resource

@export var name: StringName
@export var stream: AudioStream
@export_range(-40.0, 6.0, 0.01) var volume: float = -3.0
@export_range(0.0, 4.0, 0.01) var pitch_scale: float = 1.0
@export var pitch_randomness: float = 0.0
@export var limit: int = 10

var current_count: int = 0
func increment_count() -> void:
	current_count += 1
