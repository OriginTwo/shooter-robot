extends PanelContainer

@export var upgrades_descs: Array[UpgradesDesc]

@onready var upgrades_button_container: HBoxContainer = %UpgradesButtonContainer
@onready var base_upgrades_button: Button = %BaseUpgradesButton
@onready var points_label: Label = %PointsLabel
@onready var upgrade_description_label: Label = %UpgradeDescriptionLabel

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	reset_upgrades_labels()

	for i in len(upgrades_descs) - 1:
		var button := base_upgrades_button.duplicate()
		upgrades_button_container.add_child(button)
		@warning_ignore("confusable_local_declaration")
		var desc := upgrades_descs[i + 1]
		button.icon = desc.icon
		button.pressed.connect(on_upgrades_button_pressed.bind(desc))
		button.mouse_entered.connect(update_upgrades_labels.bind(desc))
		button.mouse_exited.connect(reset_upgrades_labels)

	var desc := upgrades_descs[0]
	base_upgrades_button.icon = desc.icon
	base_upgrades_button.pressed.connect(on_upgrades_button_pressed.bind(desc))
	base_upgrades_button.mouse_entered.connect(update_upgrades_labels.bind(desc))
	base_upgrades_button.mouse_exited.connect(reset_upgrades_labels)

	player.points_changed.connect(on_player_points_changed)

func on_upgrades_button_pressed(desc: UpgradesDesc) -> void:
	var points_required := desc.points
	desc.points += desc.points_increase
	player.points -= points_required
	SignalBus.upgrades_bought.emit(desc)
	update_upgrades_labels(desc)

func update_upgrades_labels(desc: UpgradesDesc) -> void:
	points_label.text = "%d points" % desc.points
	upgrade_description_label.text = desc.description

func reset_upgrades_labels() -> void:
	points_label.text = ""
	upgrade_description_label.text = ""

func on_player_points_changed(new_amount: int) -> void:
	var buttons := upgrades_button_container.get_children()
	for i in upgrades_button_container.get_child_count():
		buttons[i].disabled = upgrades_descs[i].points > new_amount
