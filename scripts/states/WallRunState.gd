extends State
class_name WallRunState

func enter(_previous_state_name: String = "") -> void:
	player.velocity.x = 0.0
	player.jumps_left = player.total_jumps # regrant jumps on wall grab
	player.anim.play("wall_run")

func physics_update(delta: float) -> void:
	var input_dir : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var holding_into_wall : bool = sign(input_dir) == player.facing_direction and input_dir != 0.0

	if not player.wall_check_front.is_colliding() or not holding_into_wall:
		transitioned.emit("Fall")
		return

	if Input.is_action_pressed("run"):
		player.velocity.y = -player.wall_run_speed
	else:
		player.velocity.y = min(player.velocity.y + player.gravity * delta * 0.3, player.wall_slide_speed)

	player.move_and_slide()

	if player.is_on_floor():
		transitioned.emit("Idle")
		return
	if Input.is_action_just_pressed("jump"):
		_wall_jump()
		return

func _wall_jump() -> void:
	player.velocity.x = player.wall_jump_velocity.x * -player.facing_direction
	player.velocity.y = player.wall_jump_velocity.y
	player.facing_direction *= -1.0
	player.player_sprite.flip_h = player.facing_direction < 0.0
	player.jumps_left -= 1
	player.jump_sfx.play()
	transitioned.emit("Fall")
