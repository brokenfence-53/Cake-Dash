extends StaticBody2D

func _ready() -> void:
	Events.block_break_requested.connect(_on_block_break_requested)

func _on_block_break_requested(break_position: Vector2, power: int) -> void:
	if global_position.distance_to(break_position) < 32.0:
		queue_free()
