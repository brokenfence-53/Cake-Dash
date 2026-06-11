extends Node

signal data_changed
const SAVE_PATH : String = "user://save_data.cfg"
var completed_levels : Dictionary = {}

func _ready() -> void:
	load_data()

func complete_level(level_key: String) -> void:
	if completed_levels.has(level_key):
		return
	completed_levels[level_key] = true
	save_data()
	data_changed.emit()

func is_level_completed(level_key: String) -> bool:
	return completed_levels.has(level_key)

func is_level_unlocked(level: LevelData) -> bool:
	if level.unlocked_by.is_empty():
		return true
	return is_level_completed(level.unlocked_by)

func save_data() -> void:
	var cfg := ConfigFile.new()
	for key in completed_levels.keys():
		cfg.set_value("completed", key, true)
	cfg.save(SAVE_PATH)

func load_data() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	for key in cfg.get_section_keys("completed"):
		completed_levels[key] = true
