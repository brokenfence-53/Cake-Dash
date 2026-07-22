extends CanvasLayer

@onready var retry_button : Button = $Retry
@onready var menu_button : Button = $Menu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	GameManager.game_over_triggered.connect(_on_game_over)
	retry_button.pressed.connect(_on_retry_pressed)

func _on_game_over() -> void:
	visible = true

func _on_retry_pressed() -> void:
	visible = false
	GameManager.restart_level()
