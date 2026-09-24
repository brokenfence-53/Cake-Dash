extends InteractionArea
class_name SceneDoor

@export_group("Scene Transition")
@export var target_scene: PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if not player_in_area or disabled:
		return
	if event.is_action_pressed("interact"):
		_travel()

func _travel() -> void:
	if not target_scene:
		push_warning("SceneDoor has no target_scene assigned.")
		return
	TransitionManager.change_scene(target_scene)
