extends Area2D
class_name KillZone

@export var falling_sfx : AudioStreamPlayer
@export var death_sfx : AudioStreamPlayer

var _triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if _triggered:
		return
	if not body.is_in_group("player"):
		return
	_triggered = true
	_handle_player_death(body)

func _handle_player_death(body: Node2D) -> void:
	body.set_physics_process(false)
	body.set_process_input(false)
	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO
	falling_sfx.play()
	await falling_sfx.finished
	death_sfx.play()
	GameManager.request_screen_shake(0.6)
	await death_sfx.finished
	GameManager.trigger_game_over()
	_triggered = false
