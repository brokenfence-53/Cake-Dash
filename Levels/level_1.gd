extends Node2D

func _ready() -> void:
	EventBus.level_started.emit.call_deferred()
