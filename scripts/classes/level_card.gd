class_name LevelCard
extends Button

signal level_selected(level: LevelData)

@export var level_data : LevelData
@export var lock_icon : Texture2D
@export var lock_sfx : AudioStream
@export var click_sfx : AudioStream

@onready var name_label : Label = $NameLabel
@onready var lock_icon_node : TextureRect = $LockIcon
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var _is_unlocked : bool = false

func _ready() -> void:
	assert(level_data != null, name + ": No LevelData assigned in Inspector!")
	GameData.data_changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	var is_unlocked : bool = GameData.is_level_unlocked(level_data)
	name_label.text = level_data.level_name
	if is_unlocked:
		name_label.visible = true
		modulate = Color.WHITE
		disabled = false
		lock_icon_node.visible = false
	else:
		name_label.visible = false
		modulate = Color(0.45, 0.45, 0.45, 1.0)
		disabled = true
		lock_icon_node.visible = true
		if lock_icon:
			lock_icon_node.texture = lock_icon

func _on_pressed() -> void:
	if _is_unlocked:
		_play_sfx(click_sfx)
	else:
		_play_sfx(lock_sfx)
	level_selected.emit(level_data)

func _play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	audio_player.stream = stream
	audio_player.play()
