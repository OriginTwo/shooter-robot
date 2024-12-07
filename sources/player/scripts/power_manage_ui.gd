extends HBoxContainer

@export var system_name: String

@onready var title_label: Label = $TitleLabel
@onready var decrease_button: Button = $DecreaseButton
@onready var increase_button: Button = $IncreaseButton
@onready var power_display_ui: HBoxContainer = $PowerDisplayUI

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	title_label.text = system_name
	increase_button.pressed.connect(on_power_changed.bind(true))
	decrease_button.pressed.connect(on_power_changed.bind(false))
	power_display_ui.change(player.power[system_name])

func on_power_changed(increment: bool) -> void:
	if increment:
		player.increment_power(system_name)
	else:
		player.decrement_power(system_name)
	power_display_ui.change(player.power[system_name])
