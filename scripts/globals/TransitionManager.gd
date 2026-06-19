extends CanvasLayer
class_name SceneTransition

@onready var transition_rect: ColorRect = $TransitionRect
@onready var audio_player : AudioStreamPlayer = $AudioPlayer

@export var close_sfx: AudioStream
@export var open_sfx: AudioStream

const TRANSITION_DURATION: float = 0.5

var _material: ShaderMaterial

func _ready() -> void:
	_material = transition_rect.material as ShaderMaterial
	_material.set_shader_parameter("_CirclePosition", Vector2(0.5, 0.5))
	_material.set_shader_parameter("_Progress", 1.0)
	transition_rect.visible = false

func change_scene(scene: PackedScene) -> void:
	transition_rect.visible = true
	await _close()
	get_tree().change_scene_to_packed(scene)
	await get_tree().process_frame  
	await _open()
	transition_rect.visible = false

func _close() -> void:
	_play_sfx(close_sfx)
	var tween := create_tween()
	tween.tween_method(_set_progress, 0.0, 1.0, TRANSITION_DURATION)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _open() -> void:
	_play_sfx(open_sfx)
	var tween := create_tween()
	tween.tween_method(_set_progress, 1.0, 0.0, TRANSITION_DURATION)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _set_progress(value: float) -> void:
	_material.set_shader_parameter("_Progress", value)

func _play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	audio_player.stream = stream
	audio_player.play()
