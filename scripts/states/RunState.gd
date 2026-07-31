extends State
class_name RunState

var mach_hold_time: float = 0.0

func enter(_previous_state_name: String = "") -> void:
	mach_hold_time = 0.0

func physics_update(delta: float) -> void:
	var input_dir : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.apply_horizontal_movement(delta, input_dir, player.acceleration, player.friction, player.max_speed)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	player.anim.play("walk" if abs(player.velocity.x) > 10.0 else "idle")

	if input_dir != 0.0 and Input.is_action_pressed("run"):
		mach_hold_time += delta
	else:
		mach_hold_time = 0.0

	if not player.is_on_floor():
		transitioned.emit("Fall")
		return
	if input_dir == 0.0 and abs(player.velocity.x) < 10.0:
		transitioned.emit("Idle")
		return
	if mach_hold_time >= player.mach_build_time:
		transitioned.emit("MachRun")
		return
	if Input.is_action_just_pressed("jump") or not player.jump_buffer_timer.is_stopped():
		transitioned.emit("Jump")
		return
