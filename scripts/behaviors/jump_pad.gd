extends Node2D

@export_group("Bounce")
@export var bounce_force: float = -600.0
@export var bounce_cooldown: float = 0.1
@export var restores_jumps: bool = true

@export_group("Audio")
@export var pitch_range: Vector2 = Vector2(0.9, 1.1)

@onready var bounce_detector: Area2D = $BounceDetector
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var bounce_sfx: AudioStreamPlayer = $BounceSFX

var _can_bounce: bool = true

func _ready() -> void:
	bounce_detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not _can_bounce:
		return
	if body is Player and body.velocity.y > 0.0:
		_bounce_player(body)

func _bounce_player(player: Player) -> void:
	player.velocity.y = bounce_force
	if restores_jumps:
		player.jumps_left = player.total_jumps
	player.state_machine.transition_to("Fall")

	bounce_sfx.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	bounce_sfx.play()
	anim.play("activate")

	_can_bounce = false
	await get_tree().create_timer(bounce_cooldown).timeout
	_can_bounce = true
