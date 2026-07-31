extends Node

signal block_break_requested(position: Vector2, power: int) 
signal enemy_stun_requested(enemy: Node, force: Vector2)
signal combo_changed(new_combo: int)
signal screen_shake_requested(strength: float, duration: float)
