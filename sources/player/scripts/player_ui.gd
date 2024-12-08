extends CanvasLayer

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar
@onready var energy_bar: ProgressBar = %EnergyBar
@onready var points_label: Label = %PointsLabel
@onready var upgrades_ui: PanelContainer = $UpgradesUI

var player_health: HealthComponent

func _ready() -> void:
	player_health = player.get_node("HealthComponent")

	health_bar.max_value = float(player_health.max_health)
	health_bar.value = player_health.health
	energy_bar.max_value = player.max_energy
	energy_bar.value = player.energy

	SignalBus.game_over.connect(set_process.bind(false))

	player.max_energy_changed.connect(on_player_max_energy_changed)
	player.points_changed.connect(on_player_points_changed)
	player_health.changed.connect(on_player_health_changed)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("show_upgrades"):
		upgrades_ui.show()
	elif Input.is_action_just_released("show_upgrades"):
		upgrades_ui.hide()

func _process(_delta: float) -> void:
	energy_bar.value = player.energy


func on_player_max_energy_changed(new_amount: float) -> void:
	energy_bar.max_value = new_amount

func on_player_points_changed(new_amount: int) -> void:
	points_label.text = "POINTS: %d" % new_amount

func on_player_health_changed(new_amount: int) -> void:
	health_bar.value = float(new_amount)
