extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().change_scene_to_file(str("res://Levels/main.tscn")) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(str("res://Levels/main_menu.tscn")) # Replace with function body.
