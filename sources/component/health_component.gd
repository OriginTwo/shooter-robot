class_name HealthComponent
extends Node

signal depleted
signal changed(new_amount: int)

@export var max_health: int = 3
@export var hurtbox: HurtboxComponent

@onready var health: int = max_health :
	set(new_value):
		health = clamp(new_value, 0, max_health)
		changed.emit(health)
		if health == 0:
			depleted.emit()

func _ready() -> void:
	hurtbox.hurt.connect(on_hurt)

func on_hurt(hitbox: HitboxComponent) -> void:
	health -= hitbox.damage
