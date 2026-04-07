extends CharacterBody2D

@onready var CoyoteTimer : Timer = $CoyoteTimer
@onready var JumpBufferTimer : Timer = $JumpBufferTimer
@onready var PlayerSprite : Sprite2D =  $PlayerSprite
@onready var JumpSFX : AudioStreamPlayer = $JumpSFX
@onready var anim : AnimationPlayer = $AnimationPlayer

var coyote_time_activated : bool = false

const jump_height : float = -500.0
var gravity : float = 8.0
const max_gravity : float = 18.0

const max_speed : float = 500
const acceleration : float = 12
const friction : float = 14
var jumps_left : int = 0
const total_jumps : int = 2

func _ready() -> void:
	anim.play("walk")

func _physics_process(delta : float) -> void:
	var x_input : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight : float = delta * (acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)

	if x_input != 0:
		PlayerSprite.flip_h = x_input < 0

	if is_on_floor():
		coyote_time_activated = false
		jumps_left = total_jumps
		
	if jumps_left > 0 and velocity.y >= 0.0:
		if Input.is_action_just_pressed("up"):
			velocity.y = jump_height
			jumps_left -= 1
			
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if CoyoteTimer.is_stopped() and !coyote_time_activated:
			CoyoteTimer.start()
			coyote_time_activated = true

		if Input.is_action_just_released("up") or is_on_ceiling():
			velocity.y = 0.5

		gravity = lerp(gravity, max_gravity, 12.0 * delta)

	if Input.is_action_just_pressed("up"):
		if JumpBufferTimer.is_stopped():
			JumpBufferTimer.start()

	if !JumpBufferTimer.is_stopped() and (!CoyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = jump_height
		JumpBufferTimer.stop()
		CoyoteTimer.stop()
		coyote_time_activated = true

	velocity.y += gravity
	move_and_slide()
