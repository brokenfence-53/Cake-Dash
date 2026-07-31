extends State
class_name DiveState

func enter(_previous_state_name: String = "") -> void:
	var angle_rad : float = deg_to_rad(player.dive_angle_deg)
	player.velocity = Vector2(cos(angle_rad) * player.facing_direction, sin(angle_rad)) * player.dive_speed
	player.anim.play("dive")

func physics_update(_delta: float) -> void:
	player.move_and_slide()

	if player.get_slide_collision_count() > 0:
		_handle_dive_collisions()

	if player.is_on_wall():
		player.velocity.x = 0.0
	if player.is_on_floor():
		_land()
		return

func _handle_dive_collisions() -> void:
	for i in player.get_slide_collision_count():
		var collision := player.get_slide_collision(i)
		var collider := collision.get_collider()
		if collider == null:
			continue
		if collider.is_in_group("breakable_light"):
			Events.block_break_requested.emit(collision.get_position(), 1)
		elif collider.is_in_group("enemy"):
			Events.enemy_stun_requested.emit(collider, Vector2(player.facing_direction, -1.0) * 400.0)

func _land() -> void:
	player.velocity.y = -200.0
	Events.screen_shake_requested.emit(0.2, 0.15)
	transitioned.emit("Fall")
