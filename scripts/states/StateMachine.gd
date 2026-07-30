extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.player = get_parent()
			child.state_machine = self
			child.transitioned.connect(transition_to)

	if initial_state:
		current_state = initial_state
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func transition_to(new_state_name: String) -> void:
	if not states.has(new_state_name):
		push_warning("State '%s' does not exist." % new_state_name)
		return

	var previous_state_name : String = current_state.name if current_state else ""
	if current_state:
		current_state.exit()

	current_state = states[new_state_name]
	current_state.enter(previous_state_name)
