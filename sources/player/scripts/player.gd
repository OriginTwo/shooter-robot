class_name Player
extends CharacterBody2D

const MAX_SPEED := 40.0

@onready var projectiles_container := get_tree().get_first_node_in_group("projectiles")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var laser_spawner: SpawnerComponent = $LaserSpawner

var state_machine := CallableStateMachine.new()

const MAX_ENERGY: float = 500.0
const ENERGY_RECHARGE_RATE: float = 50.0        # per second
const RUNNING_ENERGY_CONSUMPTION: float = 10.0  # per second
const SHOOTING_ENERGY_CONSUMPTION: float = 20.0 # per shot
var energy := MAX_ENERGY :
	set(new_value):
		var old_value := energy
		energy = clamp(new_value, 0.0, MAX_ENERGY)
		if energy < old_value:
			energy_recharge_cooldown_timer = ENERGY_RECHARGE_COOLDOWN_TIME

# time to wait after energy usage to begin recharge
const ENERGY_RECHARGE_COOLDOWN_TIME: float = 1.0
var energy_recharge_cooldown_timer: float


signal power_changed

var power: Dictionary = {
	"_available": 0,
	"move": 4,
	"weapon": 3,
	"craft": 3,
}

func increment_power(system_name: String) -> void:
	if power["_available"] > 0:
		power["_available"] -= 1
		power[system_name] += 1
		power_changed.emit()
		update_system_power(system_name)

func decrement_power(system_name: String) -> void:
	if power[system_name] > 0:
		power[system_name] -= 1
		power["_available"] += 1
		power_changed.emit()
		update_system_power(system_name)

func update_system_power(system_name: String) -> void:
	pass


func _ready() -> void:
	add_to_group("player")

	state_machine.add_state("idle", state_idle_process, Callable(), state_idle_enter)
	state_machine.add_state("run", Callable(), state_run_physics_process, state_run_enter)
	state_machine.set_initial_state("idle")

	health_component.depleted.connect(get_tree().call_deferred.bind("reload_current_scene"))
	hurtbox_component.hurt.connect(print.bind("hurt").unbind(1))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") &&\
			shoot_cooldown_timer.is_stopped() &&\
			energy >= SHOOTING_ENERGY_CONSUMPTION:
		var mouse_pos := get_viewport().get_mouse_position()
		var laser := laser_spawner.spawn(projectiles_container) as ProjectileComponent
		laser.direction = laser_spawner.global_position.direction_to(mouse_pos)
		shoot_cooldown_timer.start()
		energy -= SHOOTING_ENERGY_CONSUMPTION


func recharge_energy(delta: float) -> void:
	energy_recharge_cooldown_timer = max(0.0, energy_recharge_cooldown_timer - delta)
	if energy_recharge_cooldown_timer == 0.0 && energy < MAX_ENERGY:
		energy += ENERGY_RECHARGE_RATE * delta


func state_idle_enter() -> void:
	sprite.play("idle")

func state_idle_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("move_w") ||
			Input.is_action_just_pressed("move_e") ||
			Input.is_action_just_pressed("move_n") ||
			Input.is_action_just_pressed("move_s")) &&\
			energy > 0.0:
		state_machine.change_state("run")


func state_run_enter() -> void:
	sprite.play("run")

func state_run_physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	if energy > 0.0:
		input_vector.x = Input.get_axis("move_w", "move_e")
		input_vector.y = Input.get_axis("move_n", "move_s")
	velocity = input_vector.normalized() * MAX_SPEED
	energy -= RUNNING_ENERGY_CONSUMPTION * delta

	move_and_slide()

	if energy == 0.0 || input_vector == Vector2.ZERO:
		state_machine.change_state("idle")


func _process(delta: float) -> void:
	state_machine.process(delta)
	recharge_energy(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
