extends HBoxContainer

const COLORS: Array[Color] = [
	Color8(229,  59, 68),
	Color8(251, 146, 43),
	Color8(255, 231, 98),
	Color8( 99, 198, 77),
]
const DISABLED_COLOR: Color = Color8(79, 103, 129)

@onready var elems: Array[ColorRect] = [
	$ColorRect,  $ColorRect2,
	$ColorRect3, $ColorRect4,
	$ColorRect5, $ColorRect6,
	$ColorRect7, $ColorRect8,
	$ColorRect9, $ColorRect10,
]

func _ready() -> void:
	for i in len(elems):
		elems[i].color = DISABLED_COLOR

func change(new_amount: int) -> void:
	for i in len(elems):
		elems[i].color = get_color(i) if i < new_amount else DISABLED_COLOR

func get_color(index: int) -> Color:
	var color_index := int(float(index + 1) / 10 * 4)
	return COLORS[clamp(color_index, 0, len(COLORS) - 1)]
