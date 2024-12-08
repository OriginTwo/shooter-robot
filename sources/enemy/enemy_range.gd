extends CharacterBody2D

const POINTS_SCENE := preload("res://sources/enemy/points.tscn")

const MAX_SPEED := 15.0

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var health_component: HealthComponent = $HealthComponent

@onready var player := get_tree().get_first_node_in_group("player")

var state_machine := CallableStateMachine.new()

func _ready() -> void:
	state_machine.add_state("chase", Callable(), state_chase_physics_process)
	state_machine.add_state("attack", Callable(), state_attack_physics_process, state_attack_enter)
	state_machine.add_state("game_over")
	state_machine.set_initial_state("chase")

	SignalBus.game_over.connect(state_machine.change_state.bind("game_over", true))

	health_component.depleted.connect(on_health_depleted)
	health_component.changed.connect(on_health_changed)

func _process(delta: float) -> void:
	state_machine.process(delta)

var first_physics_frame := true
func _physics_process(delta: float) -> void:
	if first_physics_frame:
		first_physics_frame = false
		return
	state_machine.physics_process(delta)

func on_health_depleted() -> void:
	for i in randi_range(1, 3):
		var points := POINTS_SCENE.instantiate()
		get_tree().get_first_node_in_group("projectiles").add_child(points)
		points.global_position = global_position
		points.velocity = points.SPEED * Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)).normalized()
	$DeadParticleSpawnerComponent.spawn(get_tree().get_first_node_in_group("particles"))
	queue_free()

func on_health_changed(_new_amount: int) -> void:
	AudioManager.play_sound("enemy_hurt")
	$ShakeComponent.shake()
	$FlashComponent.flash()


func state_chase_physics_process(_delta: float) -> void:
	navigation_agent_2d.target_position = player.global_position

	var target_pos := navigation_agent_2d.get_next_path_position()
	var target_dir := global_position.direction_to(target_pos)
	velocity = target_dir * MAX_SPEED
	move_and_slide()

	if navigation_agent_2d.is_navigation_finished():
		state_machine.change_state("attack")


func state_attack_enter() -> void:
	shoot_cooldown_timer.start(0.5)

const ATTACK_RANGE: float = 70.0
func state_attack_physics_process(_delta: float) -> void:
	navigation_agent_2d.target_position = player.global_position

	var dir := global_position.direction_to(player.global_position).normalized()
	velocity = dir.orthogonal() * MAX_SPEED
	move_and_slide()

	if shoot_cooldown_timer.is_stopped():
		AudioManager.play_sound("enemy_shoot")
		$ShootParticle.emitting = true
		var laser := $LaserSpawnerComponent.spawn(
			get_tree().get_first_node_in_group("projectiles")) as ProjectileComponent
		laser.direction = dir
		shoot_cooldown_timer.start(2.5)

	if global_position.distance_squared_to(player.global_position) > ATTACK_RANGE * ATTACK_RANGE:
		state_machine.change_state("chase")
