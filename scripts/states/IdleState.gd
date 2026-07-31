extends State
class_name IdleState

func enter(_previous_state_name: String = "") -> void:
	player.anim.play("idle")

func physics_update(delta: float) -> void:
	var input_dir : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.apply_horizontal_movement(delta, input_dir, player.acceleration, player.friction, player.max_speed)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit("Fall")
		return
	if input_dir != 0.0:
		transitioned.emit("Run")
		return
	if Input.is_action_just_pressed("jump") or not player.jump_buffer_timer.is_stopped():
		transitioned.emit("Jump")
		return
