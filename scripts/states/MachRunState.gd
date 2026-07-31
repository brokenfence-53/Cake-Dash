extends State
class_name MachRunState

func enter(_previous_state_name: String = "") -> void:
	player.anim.play("mach_run")

func physics_update(delta: float) -> void:
	var input_dir : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var holding_run : bool = Input.is_action_pressed("run")

	_update_mach_level(holding_run)

	if input_dir != 0.0 and sign(input_dir) != player.facing_direction and holding_run:
		_drift_turn(input_dir)
	else:
		var tier_index : int = clampi(player.mach_level - 1, 0, player.mach_accelerations.size() - 1)
		var accel : float = player.mach_accelerations[tier_index] if player.mach_level > 0 else player.acceleration
		var top_speed : float = player.mach_speed_thresholds[mini(player.mach_level, player.mach_speed_thresholds.size() - 1)] \
			if player.mach_level > 0 else player.max_speed
		player.apply_horizontal_movement(delta, input_dir, accel, player.friction, top_speed)

	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.get_slide_collision_count() > 0:
		_handle_mach_collisions()

	if not player.is_on_floor():
		transitioned.emit("Fall")
		return
	if not holding_run or input_dir == 0.0 or abs(player.velocity.x) < player.mach_speed_thresholds[0] * 0.5:
		player.mach_level = 0
		transitioned.emit("Run")
		return
	if Input.is_action_just_pressed("jump") or not player.jump_buffer_timer.is_stopped():
		transitioned.emit("Jump")
		return

func _update_mach_level(holding_run: bool) -> void:
	if not holding_run:
		return
	var speed : float = abs(player.velocity.x)
	var new_level : int = 0
	for i in player.mach_speed_thresholds.size():
		if speed >= player.mach_speed_thresholds[i]:
			new_level = i + 1
	player.mach_level = max(player.mach_level, new_level)

func _drift_turn(input_dir: float) -> void:
	var kept_speed : float = abs(player.velocity.x) * 0.7
	player.velocity.x = input_dir * kept_speed
	player.facing_direction = sign(input_dir)
	player.player_sprite.flip_h = input_dir < 0.0

func _handle_mach_collisions() -> void:
	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider()
		if collider == null:
			continue
		if collider.is_in_group("breakable_light"):
			Events.block_break_requested.emit(collision.get_position(), 1)
		elif collider.is_in_group("breakable_heavy") and player.mach_level >= 3:
			Events.block_break_requested.emit(collision.get_position(), 2)
		elif collider.is_in_group("enemy"):
			Events.enemy_stun_requested.emit(collider, Vector2(player.facing_direction, 0.0) * 400.0)
			player.combo_count += 1
			Events.combo_changed.emit(player.combo_count)
