extends CanvasLayer

signal transition_started
signal transition_finished

var _is_transitioning : bool = false

func go_to_scene(
	scene         : PackedScene,
	completed_key : String          = "",
	anim_player   : AnimationPlayer = null,
	anim_out      : String          = "",
	anim_in       : String          = ""
) -> void:

	if _is_transitioning:
		return
	_is_transitioning = true
	transition_started.emit()

	if not completed_key.is_empty():
		GameData.complete_level(completed_key)

	if anim_player and not anim_out.is_empty():
		anim_player.play(anim_out)
		await anim_player.animation_finished

	get_tree().change_scene_to_packed(scene)

	await get_tree().process_frame

	if anim_player and not anim_in.is_empty():
		anim_player.play(anim_in)
		await anim_player.animation_finished

	_is_transitioning = false
	transition_finished.emit()
