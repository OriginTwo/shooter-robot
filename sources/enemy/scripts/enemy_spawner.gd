extends Node2D

const SPAWN_DISTANCE_FROM_PLAYER: float = 80.0

@export var enemy_scenes: Array[PackedScene]
@export var tile_map_layer: TileMapLayer

@onready var timer: Timer = $Timer
@onready var particle_spawner_component: SpawnerComponent = $ParticleSpawnerComponent

@onready var player: Player = get_tree().get_first_node_in_group("player")

var spawn_time: float = 4.0

func _ready() -> void:
	SignalBus.game_over.connect(timer.stop)

	timer.timeout.connect(on_spawn)
	timer.start(spawn_time)

func on_spawn() -> void:
	var enemy: Node2D = enemy_scenes.pick_random().instantiate()
	add_child(enemy)

	var tile_map_rect := tile_map_layer.get_used_rect()
	while true:
		var pos := Vector2i(
			randi_range(tile_map_rect.position.x, tile_map_rect.end.x),
			randi_range(tile_map_rect.position.y, tile_map_rect.end.y))
		var tile_data := tile_map_layer.get_cell_tile_data(pos)
		if !tile_data:
			continue
		if tile_data.get_custom_data("can_enemy_spawn"):
			var global_pos := to_global(tile_map_layer.map_to_local(pos))
			if global_pos.distance_squared_to(player.global_position) <= SPAWN_DISTANCE_FROM_PLAYER * SPAWN_DISTANCE_FROM_PLAYER:
				continue
			enemy.global_position = global_pos
			particle_spawner_component.spawn(get_tree().get_first_node_in_group("particles"), global_pos)
			break

	timer.start(spawn_time)
