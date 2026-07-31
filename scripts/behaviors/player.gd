extends CharacterBody2D
class_name Player

@onready var coyote_timer : Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer : Timer = $Timers/JumpBufferTimer

@onready var player_sprite : Sprite2D = $PlayerSprite
@onready var anim : AnimationPlayer = $AnimationPlayer

@onready var jump_sfx : AudioStreamPlayer = $SFX/JumpSFX
@onready var hurt_sfx : AudioStreamPlayer = $SFX/HurtSFX
@onready var dash_sfx : AudioStreamPlayer = $SFX/DashSFX

@onready var wall_check_front : RayCast2D = $WallDetector/WallCheckFront
@onready var fall_height_tracker : FallHeightTracker = $FallHeightTracker
@onready var state_machine : StateMachine = $StateMachine

@export_group("Ground Movement")
@export var max_speed : float = 500.0
@export var acceleration : float = 12.0
@export var friction: float = 14.0

@export_group("Mach Run")
@export var mach_build_time: float = 0.6
@export var mach_speed_thresholds: Array[float] = [150.0, 260.0, 380.0, 500.0]
@export var mach_accelerations: Array[float] = [12.0, 16.0, 20.0, 26.0]

@export_group("Jump")
@export var jump_height: float = -500.0
@export var gravity: float = 900.0
@export var max_gravity: float = 1800.0
@export var total_jumps: int = 2
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@export_group("Dive")
@export var dive_speed: float = 700.0
@export var dive_angle_deg: float = 45.0

@export_group("Ground Pound")
@export var ground_pound_speed: float = 1400.0
@export var light_block_break_height: float = 100.0
@export var heavy_block_break_height: float = 250.0

@export_group("Wall")
@export var wall_run_speed: float = 300.0
@export var wall_slide_speed: float = 100.0
@export var wall_jump_velocity: Vector2 = Vector2(400.0, -450.0)

var jumps_left: int = 0
var facing_direction: float = 1.0
var mach_level: int = 0
var combo_count: int = 0
var was_on_floor: bool = true

func _ready() -> void:
	jumps_left = total_jumps
	coyote_timer.wait_time = coyote_time
	jump_buffer_timer.wait_time = jump_buffer_time
	state_machine.start()

func _physics_process(delta: float) -> void:
	wall_check_front.target_position.x = abs(wall_check_front.target_position.x) * facing_direction
	if is_on_floor():
		if not was_on_floor:
			jumps_left = total_jumps
			coyote_timer.stop()
		was_on_floor = true
	else:
		if was_on_floor:
			coyote_timer.start()
		was_on_floor = false

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()

func apply_horizontal_movement(delta: float, input_dir: float, accel: float, fric: float, speed_cap: float) -> void:
	var weight : float = delta * (accel if input_dir else fric)
	velocity.x = lerp(velocity.x, input_dir * speed_cap, weight)
	if input_dir != 0.0:
		facing_direction = sign(input_dir)
		player_sprite.flip_h = input_dir < 0.0

func perform_jump() -> void:
	velocity.y = jump_height
	jumps_left -= 1
	jump_buffer_timer.stop()
	coyote_timer.stop()
	jump_sfx.play()
	anim.play("jump")
