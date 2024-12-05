extends CharacterBody2D

const MAX_SPEED := 25.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var input_vector: Vector2

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	input_vector.x = Input.get_axis("move_w", "move_e")
	input_vector.y = Input.get_axis("move_n", "move_s")
	velocity = input_vector.normalized() * MAX_SPEED
	velocity.x *= 2.0

	if !velocity.is_zero_approx():
		sprite.play("run")
	else:
		sprite.play("idle")

	move_and_slide()
