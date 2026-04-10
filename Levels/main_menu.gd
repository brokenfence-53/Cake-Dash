extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(str("res://Levels/main.tscn")) # Replace with function body.


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file(str("res://Levels/main.tscn")) # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.
