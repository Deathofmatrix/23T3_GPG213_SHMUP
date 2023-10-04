class_name FollowEnemy
extends Enemy

@export var movement_speed: int = 50
@export var points = 100

func _process(_delta):
	var direction = Vector2(0,1)
	direction.x = global_position.direction_to(GlobalPlayerInfo.player_position).x
	velocity = direction * movement_speed
	move_and_slide()

#
func _on_health_system_killed():
	print(name + "killed")
	EventManager.emit_signal("enemy_destroyed", global_position, points)


func _on_health_system_health_updated(_health):
	hit_flash($Sprite2D)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
