class_name UpgradesDesc
extends Resource

enum Kind {
	HEAL,
	ENERGY_CAPACITY,
	ENERGY_RECHARGE,
}

@export var kind: Kind
@export_multiline var description: String
@export var icon: AtlasTexture
@export var points: int
@export var points_increase: int
