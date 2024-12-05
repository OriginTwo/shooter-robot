class_name CallableStateMachine

var states: Dictionary
var current_state_name: StringName

func add_state(
		name: StringName,
		process: Callable,
		physics := Callable(),
		enter := Callable(),
		leave := Callable()):
	states[name] = {}
	if process.is_valid():
		states[name]["process"] = process
	if physics.is_valid():
		states[name]["physics"] = physics
	if enter.is_valid():
		states[name]["enter"] = enter
	if leave.is_valid():
		states[name]["leave"] = leave

func set_initial_state(state: StringName):
	change_state(state, true)

func process(delta: float):
	if states[current_state_name].has("process"):
		states[current_state_name]["process"].call(delta)

func physics(delta: float):
	if states[current_state_name].has("physics"):
		states[current_state_name]["physics"].call(delta)

func change_state(new_state: StringName, immediate: bool = false):
	var change_func := func():
		if states.has(new_state):
			if current_state_name && states[current_state_name].has("leave"):
				states[current_state_name]["leave"].call()
			if states[new_state].has("enter"):
				states[new_state]["enter"].call()

		current_state_name = new_state

	if !immediate:
		change_func.call_deferred()
	else:
		change_func.call()
