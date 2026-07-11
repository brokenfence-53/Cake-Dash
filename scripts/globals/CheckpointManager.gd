extends Node

signal checkpoint_changed(new_position: Vector2)

var current_checkpoint: Checkpoint = null
var current_checkpoint_position: Vector2 = Vector2.ZERO

func set_checkpoint(checkpoint_node: Checkpoint, world_position: Vector2) -> void:
	if current_checkpoint and current_checkpoint != checkpoint_node:
		current_checkpoint.deactivate()
	current_checkpoint = checkpoint_node
	current_checkpoint_position = world_position
	checkpoint_changed.emit(world_position)

func get_respawn_position() -> Vector2:
	return current_checkpoint_position

func reset() -> void:
	if current_checkpoint:
		current_checkpoint.deactivate()
	current_checkpoint = null
	current_checkpoint_position = Vector2.ZERO
