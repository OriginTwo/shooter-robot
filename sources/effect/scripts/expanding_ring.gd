@tool
class_name ExpandingRingEffect
extends Node2D

@export var radius: float = 10.0
@export_range(0.0, 1.0) var radius_start_percent: float = 0.5
@export var thickness: float = 5.0
@export var color: Color = Color.WHITE
@export_range(0.0, 1.0) var progress: float

@onready var current_radius: float = radius / 2.0
@onready var current_thickness: float = thickness

func _process(_delta: float) -> void:
	current_radius = lerpf(radius * radius_start_percent, radius, progress)
	current_thickness = lerpf(thickness, 0.0, progress)
	queue_redraw()

func _draw() -> void:
	if current_thickness > 0.0:
		draw_circle(Vector2.ZERO, current_radius, color, false, current_thickness, false)
