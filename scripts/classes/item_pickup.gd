extends Area2D
class_name ItemPickup

var value : int = 1

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		queue_free()
