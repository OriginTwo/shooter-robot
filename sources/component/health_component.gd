class_name HealthComponent
extends Node

signal depleted
signal changed(new_amount: int)
signal reduced

@export var max_health: int = 3
@export var hurtbox: HurtboxComponent

@onready var health: int = max_health :
	set(new_value):
		var old_value := health
		health = clamp(new_value, 0, max_health)
		if health != old_value:
			changed.emit(health)
		if health < old_value:
			reduced.emit()
		if old_value != 0 && health == 0:
			depleted.emit()

func _ready() -> void:
	hurtbox.hurt.connect(on_hurt)

func on_hurt(hitbox: HitboxComponent) -> void:
	health -= hitbox.damage
