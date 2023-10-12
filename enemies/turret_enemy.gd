class_name TurretEnemy
extends CharacterBody2D


@export var speed = 100  
var initial_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var end_position: Vector2

func _ready():
	position = initial_position
	target_position = end_position
	start_moving()

func start_moving():
	if !is_moving:
#		move_to(target_position)
		is_moving = true

func stop_moving():
#	move_and_slide(Vector2.ZERO)
	is_moving = false

func _process(delta):
	if is_moving and position.distance_to(target_position) < 1.0:
		# The enemy is close to the target position, so stop moving.
		position = target_position
		stop_moving()

# Once in place it starts shooting at the player

# has around same health as asteroids
