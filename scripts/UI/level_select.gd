extends Node2D

@onready var level_grid : GridContainer = $CenterContainer/LevelGrid

func _ready() -> void:
	_connect_cards()

func _connect_cards() -> void:
	for child in level_grid.get_children():
		if child is LevelCard:
			if child.level_selected.is_connected(_on_level_selected):
				child.level_selected.disconnect(_on_level_selected)
			child.level_selected.connect(_on_level_selected)

func _on_level_selected(level: LevelData) -> void:
	TransitionManager.go_to_scene(
		level.scene,
		"",
		$AnimationPlayer,
		"close",
		"open"
	)
