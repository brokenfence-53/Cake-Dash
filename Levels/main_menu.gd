extends Control
@onready var HoverSFX : AudioStreamPlayer = $Audio/HoverSFX
@onready var SelectSFX : AudioStreamPlayer = $Audio/SelectSFX
@onready var MenuMusic : AudioStreamPlayer = $Audio/MenuMusic

func _ready() -> void:
	MenuMusic.play()

func _process(_delta: float) -> void:
	pass

func _on_continue_pressed() -> void:
	MenuMusic.stop()
	SelectSFX.play()
	get_tree().change_scene_to_file("res://Levels/main.tscn") 

func _on_new_game_pressed() -> void:
	SelectSFX.play()
	get_tree().change_scene_to_file("res://Levels/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit() 
