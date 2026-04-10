extends CharacterBody2D

@onready var player : Node2D = get_tree().get_first_node_in_group("player")
# This line ^ finds the Player in the scene and stores it in a variable, 
# so the enemy always knows where the player is.”

@onready var enemy_sprite : Sprite2D = $EnemySprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var leftray : RayCast2D = $LeftRay
@onready var rightray : RayCast2D = $RightRay
@onready var leftwallray : RayCast2D = $LeftWallRay
@onready var rightwallray : RayCast2D = $RightWallRay

@export var health_amount := 10
@export_range(-1, 1) var dir: int = 1
var speed: float = 35.0
var gravity = 15

func _ready() -> void:
	if dir == 0:
		dir = 1
	enemy_sprite.flip_h = false if dir == 1 else true

func _physics_process(_delta: float) -> void:
	if dir == 1 and (!rightray.is_colliding() or rightwallray.is_colliding()):
		enemy_sprite.flip_h = true
		dir = 0
		_wait_dir_change(-1)
	if dir == -1 and (!leftray.is_colliding() or leftwallray.is_colliding()):
		enemy_sprite.flip_h = false
		dir = 0
		_wait_dir_change(1)

	velocity.x = lerp(velocity.x, dir * speed, 10.0 * _delta)
	velocity.y += gravity
	move_and_slide()

func _wait_dir_change(desired_dir: int):
	await get_tree().create_timer(0.5).timeout
	dir = desired_dir

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == player:
		pass # Place holder for future stuff
