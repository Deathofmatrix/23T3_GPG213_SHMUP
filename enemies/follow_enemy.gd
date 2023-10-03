class_name FollowEnemy
extends CharacterBody2D

@export var movement_speed: int = 50

func _process(_delta):
	var direction = Vector2(0,1)
	direction.x = position.direction_to(GlobalPlayerInfo.player_position).x
	velocity = direction * movement_speed
	move_and_slide()

#
func _on_health_system_killed():
	print(name + "killed")
