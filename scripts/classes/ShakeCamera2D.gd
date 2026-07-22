extends Camera2D
class_name ShakeCamera2D

@export var max_offset: Vector2 = Vector2(16, 10)
@export var noise_speed: float = 40.0

var _trauma: float = 0.0
var _trauma_power: float = 2.0
var _noise: FastNoiseLite = FastNoiseLite.new()
var _noise_seed_x: int = 0
var _noise_seed_y: int = 1000

func _ready() -> void:
	_noise.seed = randi()
	GameManager.screen_shake_requested.connect(_on_shake_requested)

func _on_shake_requested(strength: float) -> void:
	_trauma = clamp(_trauma + strength, 0.0, 1.0)

func _process(delta: float) -> void:
	if _trauma <= 0.0:
		offset = Vector2.ZERO
		return

	_trauma = max(_trauma - delta, 0.0) 
	var amount: float = pow(_trauma, _trauma_power)
	var time: float = Time.get_ticks_msec() / 1000.0 * noise_speed

	var offset_x: float = _noise.get_noise_2d(time, _noise_seed_x) * max_offset.x * amount
	var offset_y: float = _noise.get_noise_2d(time, _noise_seed_y) * max_offset.y * amount
	offset = Vector2(offset_x, offset_y)
