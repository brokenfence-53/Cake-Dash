extends Control
@onready var HoverSFX : AudioStreamPlayer = $Audio/HoverSFX
@onready var SelectSFX : AudioStreamPlayer = $Audio/SelectSFX
@onready var MenuMusic : AudioStreamPlayer = $Audio/MenuMusic

const LEVEL_SELECT_SCENE : PackedScene = preload("res://scenes/menus/photo_album.tscn")

func _ready() -> void:
	MenuMusic.play()

func _process(_delta: float) -> void:
	pass

func _on_continue_pressed() -> void:
	MenuMusic.stop()
	SelectSFX.play()
	TransitionManager.change_scene(LEVEL_SELECT_SCENE)

func _on_new_game_pressed() -> void:
	SelectSFX.play()
	TransitionManager.change_scene(LEVEL_SELECT_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit() 
