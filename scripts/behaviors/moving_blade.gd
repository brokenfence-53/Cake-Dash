extends Area2D

@export_group("Movement Points")
@export var point_a: Marker2D
@export var point_b: Marker2D

@export_group("Motion")
@export var move_speed: float = 100.0
@export var wait_time: float = 0.0

@export_group("Damage")
@export var damage_amount: int = 1
@export var knockback_force: Vector2 = Vector2(300.0, -300.0)

@onready var anim: AnimationPlayer = $AnimationPlayer

var _heading_to_b: bool = true
var _waiting: bool = false
var _wait_elapsed: float = 0.0

func _ready() -> void:
	anim.play("spin")
	body_entered.connect(_on_body_entered)
	if point_a:
		global_position = point_a.global_position

func _physics_process(delta: float) -> void:
	_move_along_path(delta)

func _move_along_path(delta: float) -> void:
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

func _on_body_entered(body: Node2D) -> void:
	if not (body is Player):
		return
	var away_from_blade: float = sign(body.global_position.x - global_position.x)
	var knockback: Vector2 = Vector2(knockback_force.x * away_from_blade, knockback_force.y)
	body.take_damage(damage_amount, knockback)
