extends Node

signal level_started
signal level_finished
signal level_reset
signal timer_pause_changed(paused: bool)

func emit_level_started() -> void:
	level_started.emit()

func emit_level_finished() -> void:
	level_finished.emit()

func emit_level_reset() -> void:
	level_reset.emit()

func emit_timer_pause_changed(paused: bool) -> void:
	timer_pause_changed.emit(paused)
