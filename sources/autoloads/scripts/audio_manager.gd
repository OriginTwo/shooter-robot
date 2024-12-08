extends Node2D

@export var sounds: Array[SoundDesc]

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var sound_dict: Dictionary

func _ready() -> void:
	for sound in sounds:
		sound_dict[sound.name] = sound

func play_music() -> void:
	if !music_player.playing:
		music_player.play()

func play_sound(sound_name: StringName) -> void:
	if !sound_dict.has(sound_name):
		push_warning("Sound name '%s' doesn't exist" % sound_name)
		return

	var sound: SoundDesc = sound_dict[sound_name]
	if sound.current_count >= sound.limit:
		return

	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.finished.connect(func() -> void:
		audio.queue_free()
		sound.current_count -= 1)

	sound.current_count += 1

	audio.stream = sound.stream
	audio.volume_db = sound.volume
	audio.pitch_scale = sound.pitch_scale
	audio.pitch_scale += randf_range(-sound.pitch_randomness, sound.pitch_randomness)
	audio.play()
