extends Control

# exports 
@export var time_format: String = "%02d:%02d.%02d"   # mm:ss.cs

# node refs 
@onready var timer_label: Label    = $TimerLabel
@onready var best_label:  Label    = $BestTimeLabel

# state 
var elapsed:    float = 0.0
var is_running: bool  = false
var is_paused:  bool  = false
var best_time:  float = INF

func _ready() -> void:
	_update_display(0.0)
	best_label.text = "Best: --:--.--"

	EventBus.level_started.connect(_on_level_started)
	EventBus.level_finished.connect(_on_level_finished)
	EventBus.level_reset.connect(_on_level_reset)
	EventBus.timer_pause_changed.connect(_on_pause_changed)

func _process(delta: float) -> void:
	if not is_running or is_paused:
		return
	elapsed += delta
	_update_display(elapsed)

# signal handlers 
func _on_level_started() -> void:
	elapsed    = 0.0
	is_running = true
	is_paused  = false
	_update_display(0.0)

func _on_level_finished() -> void:
	is_running = false
	_check_best_time()

func _on_level_reset() -> void:
	is_running = false
	elapsed    = 0.0
	_update_display(0.0)

func _on_pause_changed(paused: bool) -> void:
	is_paused = paused

# helpers 
func _update_display(time: float) -> void:
	timer_label.text = _format_time(time)

func _check_best_time() -> void:
	if elapsed < best_time:
		best_time = elapsed
		best_label.text = "Best: " + _format_time(best_time)

func _format_time(time: float) -> String:
	var minutes:      int = int(time) / 60
	var seconds:      int = int(time) % 60
	var centiseconds: int = int(fmod(time, 1.0) * 100)
	return time_format % [minutes, seconds, centiseconds]
