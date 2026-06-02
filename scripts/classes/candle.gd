extends Area2D
class_name Candle

@export var candle_value : int = 1
const ANIM_COLLECT := "collect"

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var collect_sfx : AudioStreamPlayer = $CollectSFX
@onready var collision : CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	anim.play("idle")
	add_to_group("candle")

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	_collect()

func _collect() -> void:
	collision.set_deferred("disabled", true)
	set_deferred("monitoring", false)
	collect_sfx.play()
	anim.play(ANIM_COLLECT)
	await anim.animation_finished
	queue_free()
