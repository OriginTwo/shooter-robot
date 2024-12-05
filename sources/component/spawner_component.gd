class_name SpawnerComponent
extends Node2D

@export var scene: PackedScene

func spawn(parent: Node = get_tree().current_scene, pos: Vector2 = global_position) -> Node:
	var instance := scene.instantiate()
	parent.add_child(instance)
	instance.global_position = pos
	return instance
