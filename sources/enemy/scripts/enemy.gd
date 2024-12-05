extends CharacterBody2D

const MAX_SPEED := 15.0

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var first_physics_frame := true

func _physics_process(_delta: float) -> void:
	if first_physics_frame:
		first_physics_frame = false
		return

	navigation_agent_2d.target_position = get_tree().get_first_node_in_group("player").global_position
	if !navigation_agent_2d.is_navigation_finished():
		var target_pos := navigation_agent_2d.get_next_path_position()
		var target_dir := global_position.direction_to(target_pos)
		velocity = target_dir * MAX_SPEED
		velocity.x *= 2.0
		move_and_slide()
