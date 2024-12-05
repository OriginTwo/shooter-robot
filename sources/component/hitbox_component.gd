class_name HitboxComponent
extends Area2D

signal hit(hurtbox: HurtboxComponent)

func _ready() -> void:
	area_entered.connect(on_hurtbox_entered)

func on_hurtbox_entered(hurtbox: HurtboxComponent) -> void:
	if !hurtbox is HurtboxComponent:
		return
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
