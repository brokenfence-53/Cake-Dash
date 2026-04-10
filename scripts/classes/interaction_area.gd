extends Area2D
class_name InteractionArea

@onready var player : Node2D = get_tree().get_first_node_in_group("player")
@onready var popup_sprite : Sprite2D = $Sprite2D

var player_in_area := false
var disabled := false

func _ready() -> void:
	popup_sprite.hide()

func _disable() -> void:
	disabled = true
	popup_sprite.hide()

func _enable() -> void:
	disabled = false
	if player_in_area:
		popup_sprite.show()

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_area = true
	if not disabled:
		popup_sprite.show()

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_area = false
		popup_sprite.hide()
