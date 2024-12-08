class_name ProjectileComponent
extends HitboxComponent

@export var hit_spawner: SpawnerComponent
@export var rotate_hit_spawner: bool
@export var speed: float = 100.0
@export_range(0.1, 100.0) var lifetime: float = 1.0

var direction: Vector2

func _ready() -> void:
	super()
	hit.connect(on_hit.unbind(1))
	get_tree().create_timer(lifetime).timeout.connect(on_hit)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func on_hit() -> void:
	AudioManager.play_sound("player_laser_timeout")
	var particle := hit_spawner.spawn(get_tree().get_first_node_in_group("particles")) as Node2D
	if rotate_hit_spawner:
		particle.global_rotation = direction.angle()
	queue_free()
