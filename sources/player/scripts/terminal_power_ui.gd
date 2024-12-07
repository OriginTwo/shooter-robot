extends VBoxContainer

@onready var available_power_display_ui: HBoxContainer = %AvailablePowerDisplayUI

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	available_power_display_ui.change(player.power["_available"])
	player.power_changed.connect(on_player_power_changed)

func on_player_power_changed() -> void:
	print("available change")
	available_power_display_ui.change(player.power["_available"])
