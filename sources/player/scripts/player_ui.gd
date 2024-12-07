extends CanvasLayer

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar
@onready var energy_bar: ProgressBar = %EnergyBar

var player_health: HealthComponent

func _ready() -> void:
	player_health = player.get_node("HealthComponent")
	player_health.changed.connect(on_player_health_changed)

	health_bar.max_value = float(player_health.max_health)
	health_bar.value = player_health.health
	energy_bar.max_value = player.MAX_ENERGY
	energy_bar.value = player.energy

func _process(_delta: float) -> void:
	energy_bar.value = player.energy

func on_player_health_changed(new_amount: int) -> void:
	health_bar.value = float(new_amount)
