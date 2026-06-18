class_name PhotoCard
extends Button

signal level_selected(level: LevelData)

@export var level_data: LevelData
@export var level_scene: PackedScene
@export var lock_icon: Texture2D
@export var lock_sfx: AudioStream
@export var click_sfx: AudioStream

@onready var lock_icon_node: TextureRect = $LockIcon
@onready var description_label: Label = $DescriptionLabel
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var picture : TextureRect = $Picture

const LABEL_HIDDEN_Y: float = 180.0
const LABEL_SHOWN_Y: float = 216.0

const HOVER_SCALE: Vector2 = Vector2(1.12, 1.12)
const HOVER_ROTATION_DEG: float = 4.0
const SNAP_DURATION: float = 0.12
const RETURN_DURATION: float = 0.18

var _base_rotation: float = 0.0
var _hover_tween: Tween

func _ready() -> void:
	assert(level_data != null, name + ": No LevelData assigned in Inspector!")
	description_label.position.y = LABEL_HIDDEN_Y
	pivot_offset = size / 2.0
	_base_rotation = rotation_degrees

	mouse_entered.connect(_on_hover_enter)
	mouse_exited.connect(_on_hover_exit)
	pressed.connect(_on_pressed)
	GameData.data_changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	var is_unlocked: bool = GameData.is_level_unlocked(level_data)
	if is_unlocked:
		picture.modulate = Color.WHITE
		modulate = Color.WHITE
		disabled = false
		lock_icon_node.visible = false
	else:
		picture.modulate = Color.BLACK
		modulate = Color(0.45, 0.45, 0.45, 1.0)
		disabled = true
		lock_icon_node.visible = true
		if lock_icon:
			lock_icon_node.texture = lock_icon

func _on_hover_enter() -> void:
	if disabled:
		return
	anim.play("label_slide_out")
	_play_snap_in()

func _on_hover_exit() -> void:
	anim.play("label_slide_in")
	_play_snap_out()

func _play_snap_in() -> void:
	if _hover_tween:
		_hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.set_trans(Tween.TRANS_BACK)
	_hover_tween.set_ease(Tween.EASE_OUT)

	_hover_tween.set_parallel(true)
	_hover_tween.tween_property(self, "scale", HOVER_SCALE, SNAP_DURATION)
	_hover_tween.tween_property(
		self, "rotation_degrees", _base_rotation + HOVER_ROTATION_DEG, SNAP_DURATION
	)

	_hover_tween.set_parallel(false)
	_hover_tween.tween_property(self, "rotation_degrees", _base_rotation, SNAP_DURATION * 0.8)

func _play_snap_out() -> void:
	if _hover_tween:
		_hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.set_trans(Tween.TRANS_BACK)
	_hover_tween.set_ease(Tween.EASE_IN)
	_hover_tween.set_parallel(true)
	_hover_tween.tween_property(self, "scale", Vector2.ONE, RETURN_DURATION)
	_hover_tween.tween_property(self, "rotation_degrees", _base_rotation, RETURN_DURATION)

func _on_pressed() -> void:
	if not disabled:
		_play_sfx(click_sfx)
		level_selected.emit(level_data)
	else:
		_play_sfx(lock_sfx)

func _play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
