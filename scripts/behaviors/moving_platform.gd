extends AnimatableBody2D
class_name MovingPlatform

@export_group("Movement Points")
@export var point_a: Marker2D
@export var point_b: Marker2D

@export_group("Motion")
@export var move_speed: float = 100.0
@export var wait_time: float = 0.0 ## Seconds to pause at each endpoint

var _heading_to_b: bool = true
var _waiting: bool = false
var _wait_elapsed: float = 0.0

func _ready() -> void:
	if point_a:
		global_position = point_a.global_position

func _physics_process(delta: float) -> void:
	if not (point_a and point_b):
		return

	if _waiting:
		_wait_elapsed += delta
		if _wait_elapsed >= wait_time:
			_waiting = false
			_wait_elapsed = 0.0
		return

	var destination: Vector2 = point_b.global_position if _heading_to_b else point_a.global_position
	global_position = global_position.move_toward(destination, move_speed * delta)

	if global_position.distance_to(destination) < 0.5:
		_heading_to_b = not _heading_to_b
		_waiting = wait_time > 0.0
