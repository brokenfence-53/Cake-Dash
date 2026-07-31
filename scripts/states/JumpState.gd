extends State
class_name JumpState

func enter(_previous_state_name: String = "") -> void:
	player.perform_jump()

func physics_update(delta: float) -> void:
	var input_dir : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.apply_horizontal_movement(delta, input_dir, player.acceleration, player.friction, player.max_speed)

	if Input.is_action_just_released("jump") and player.velocity.y < 0.0:
		player.velocity.y *= 0.5 

	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	_check_wall_grab(input_dir)

	if Input.is_action_just_pressed("jump") and player.jumps_left > 0:
		transitioned.emit("Jump")
		return
	if Input.is_action_just_pressed("down"):
		transitioned.emit("Dive" if abs(player.velocity.x) > 50.0 else "GroundPound")
		return
	if player.velocity.y >= 0.0:
		transitioned.emit("Fall")
		return

func _check_wall_grab(input_dir: float) -> void:
	if player.wall_check_front.is_colliding() and sign(input_dir) == player.facing_direction:
		transitioned.emit("WallRun")
