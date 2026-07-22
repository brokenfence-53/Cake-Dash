extends Node

signal game_over_triggered
signal game_restarted
signal screen_shake_requested(strength: float)

func trigger_game_over() -> void:
	get_tree().paused = true
	game_over_triggered.emit()

func restart_level() -> void:
	get_tree().paused = false
	game_restarted.emit()
	get_tree().reload_current_scene()

func request_screen_shake(strength: float = 0.6) -> void:
	screen_shake_requested.emit(strength)
