extends Area2D
class_name Checkpoint

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var balloon_sprite : Sprite2D = $BalloonSprite
@onready var check_sfx : AudioStreamPlayer = $SFX/CheckSFX

var is_active: bool = false

func _ready() -> void:
	anim.animation_finished.connect(_on_anim_finished)
	body_entered.connect(_on_body_entered)
	anim.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if is_active:
		return
	if body.is_in_group("player"):
		activate()

func activate() -> void:
	CheckpointManager.set_checkpoint(self, global_position)
	is_active = true
	anim.play("release balloon")
	check_sfx.play()

func deactivate() -> void:
	is_active = false
	balloon_sprite.show()
	anim.play("idle")

func _on_anim_finished(anim_name: String) -> void:
	if anim_name == "release balloon":
		anim.play("idle")
