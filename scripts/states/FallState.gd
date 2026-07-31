extends State
class_name FallState

func enter(_previous_state_name: String = "") -> void:
	player.anim.play("fall")
	player.fall_height_tracker.start_tracking(player.global_position.y)

func physics_update(delta: float) -> void:
	var input_dir : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.apply_horizontal_movement(delta, input_dir, player.acceleration, player.friction, player.max_speed)
	player.velocity.y = min(player.velocity.y + player.gravity * delta, player.max_gravity)
	player.move_and_slide()

	_check_wall_grab(input_dir)

	var can_jump : bool = player.jumps_left > 0 or not player.coyote_timer.is_stopped()
	if (Input.is_action_just_pressed("jump") or not player.jump_buffer_timer.is_stopped()) and can_jump:
		transitioned.emit("Jump")
		return
	if Input.is_action_just_pressed("down"):
		transitioned.emit("Dive" if abs(player.velocity.x) > 50.0 else "GroundPound")
		return
	if player.is_on_floor():
		player.fall_height_tracker.stop_tracking()
		transitioned.emit("Run" if input_dir != 0.0 else "Idle")
		return

func _check_wall_grab(input_dir: float) -> void:
	if player.wall_check_front.is_colliding() and sign(input_dir) == player.facing_direction:
		transitioned.emit("WallRun")
