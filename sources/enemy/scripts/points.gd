extends Node2D

const SPEED: float = 120.0
const STEER_FORCE: float = 0.05
const TRAIL_POINT_COUNT: int = 16
const COLLECTION_RADIUS: float = 4.0

@onready var trail: Line2D = $Trail

@onready var player: Player = get_tree().get_first_node_in_group("player")

var velocity: Vector2

func _physics_process(delta: float) -> void:
	var player_pos := player.global_position
	player_pos.y -= 5.0

	var desired_vel := global_position.direction_to(player_pos) * SPEED
	var steer := desired_vel - velocity
	velocity += steer * STEER_FORCE
	global_position += velocity * delta

	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0.0
	trail.add_point(global_position)
	while trail.get_point_count() > TRAIL_POINT_COUNT:
		trail.remove_point(0)

	if global_position.distance_squared_to(player_pos) <= COLLECTION_RADIUS * COLLECTION_RADIUS:
		player.points += 1
		$SpawnerComponent.spawn(get_tree().get_first_node_in_group("particles"))
		queue_free()
