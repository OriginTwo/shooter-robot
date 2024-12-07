class_name FlashComponent
extends Node

const FLASH_SHADER := preload("res://sources/component/shaders/flash.gdshader")

@export var actor: Node2D
@export var duration: float = 0.25

var flash_material := ShaderMaterial.new()
var og_material: Material
var current_strength: float
var decay: float

func _ready() -> void:
	flash_material.shader = FLASH_SHADER
	og_material = actor.material
	decay = 1.0/duration

func _process(delta: float) -> void:
	flash_material.set_shader_parameter("strength", current_strength)
	current_strength = max(0.0, current_strength - decay * delta)

	if current_strength == 0.0:
		actor.material = og_material

func flash(strength: float = 1.0) -> void:
	current_strength = clamp(current_strength + strength, 0.0, 1.0)
	actor.material = flash_material
