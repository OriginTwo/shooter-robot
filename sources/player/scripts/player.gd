extends CharacterBody2D

const MAX_SPEED := 40.0

@onready var projectiles_container := get_tree().get_first_node_in_group("projectiles")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var laser_spawner: SpawnerComponent = $LaserSpawner

var state_machine := CallableStateMachine.new()

var input_vector: Vector2

func _ready() -> void:
	add_to_group("player")

	health_component.depleted.connect(get_tree().call_deferred.bind("reload_current_scene"))
	hurtbox_component.hurt.connect(print.bind("hurt").unbind(1))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && shoot_cooldown_timer.is_stopped():
		var mouse_pos := get_viewport().get_mouse_position()
		var laser := laser_spawner.spawn(projectiles_container) as ProjectileComponent
		laser.direction = laser_spawner.global_position.direction_to(mouse_pos)
		shoot_cooldown_timer.start()

func _physics_process(_delta: float) -> void:
	input_vector.x = Input.get_axis("move_w", "move_e")
	input_vector.y = Input.get_axis("move_n", "move_s")
	velocity = input_vector.normalized() * MAX_SPEED

	if !velocity.is_zero_approx():
		sprite.play("run")
	else:
		sprite.play("idle")

	move_and_slide()
