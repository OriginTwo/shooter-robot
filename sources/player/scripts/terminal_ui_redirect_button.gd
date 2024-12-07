extends Button

@export_file("*.tscn") var scene_path: String

func _ready() -> void:
	pressed.connect(on_button_pressed)

func on_button_pressed() -> void:
	var instance: Node = load(scene_path).instantiate()
	get_parent().add_sibling(instance)
	get_parent().queue_free()
