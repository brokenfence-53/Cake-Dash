extends Node
class_name State

var player: CharacterBody2D
var state_machine: StateMachine

signal transitioned(new_state_name: String)

func enter(_previous_state_name: String = "") -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
