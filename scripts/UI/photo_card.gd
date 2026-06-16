class_name PhotoCard
extends Button

signal card_pressed(scene: PackedScene)

@export var level_scene: PackedScene
@export var data: LevelData

@onready var locked_overlay: ColorRect = $LockedOverlay
@onready var description_label: Label = $DescriptionLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

const LABEL_HIDDEN_Y: float = 0.0
const LABEL_SHOWN_Y: float = 210.0

func _ready() -> void:
	_apply_data()
	mouse_entered.connect(_on_hover_enter)
	mouse_exited.connect(_on_hover_exit)
	pressed.connect(_on_card_pressed)
	description_label.position.y = LABEL_HIDDEN_Y

func _apply_data() -> void:
	if data == null:
		push_warning("PhotoCard '%s' has no LevelData assigned." % name)
		return
	if data.thumbnail:
		texture_normal = data.thumbnail
	description_label.text = data.description
	locked_overlay.visible = !data.is_unlocked
	disabled = !data.is_unlocked

func _on_hover_enter() -> void:
	if data and data.is_unlocked:
		anim.play("label_slide_out")

func _on_hover_exit() -> void:
	anim.play("label_slide_in")

func _on_card_pressed() -> void:
	if data and data.is_unlocked and level_scene:
		card_pressed.emit(level_scene)
