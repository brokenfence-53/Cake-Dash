class_name GroundPoundState
extends State

func enter(_previous_state_name: String = "") -> void:
	player.velocity.x = 0.0
	player.velocity.y = player.ground_pound_speed
	player.anim.play("ground_pound")
	player.fall_height_tracker.start_tracking(player.global_position.y)

	if not player.anim.is_connected("animation_finished", _on_squash_land_finished):
		player.anim.animation_finished.connect(_on_squash_land_finished)

func physics_update(_delta: float) -> void:
	player.move_and_slide()
	if player.is_on_floor():
		_slam_impact()
		return

func _slam_impact() -> void:
	var fall_distance: float = player.fall_height_tracker.get_fall_distance(player.global_position.y)
	player.fall_height_tracker.stop_tracking()

	var power: int = 0
	if fall_distance >= player.heavy_block_break_height:
		power = 2
	elif fall_distance >= player.light_block_break_height:
		power = 1

	if power > 0:
		Events.block_break_requested.emit(player.global_position, power)
		player.land_sfx.play()

	Events.screen_shake_requested.emit(12.0 if power == 2 else 6.0, 0.2)

	player.anim.play("squash_land")

func _on_squash_land_finished(anim_name: String) -> void:
	if anim_name == "squash_land":
		transitioned.emit("Idle")
