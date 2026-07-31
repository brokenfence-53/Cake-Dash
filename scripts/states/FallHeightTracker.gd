extends Node
class_name FallHeightTracker

var fall_start_y: float = 0.0
var is_tracking: bool = false

func start_tracking(current_y: float) -> void:
	if is_tracking:
		return
	fall_start_y = current_y
	is_tracking = true

func get_fall_distance(current_y: float) -> float:
	return current_y - fall_start_y if is_tracking else 0.0

func stop_tracking() -> void:
	is_tracking = false
