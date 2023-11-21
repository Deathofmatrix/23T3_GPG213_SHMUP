class_name FollowEnemyMiniboss
extends Enemy

var direction = Vector2(0,1)

@export var movement_speed: int = 50

func _process(_delta):
	direction = global_position.direction_to(GlobalPlayerInfo.player_position)
	look_at(GlobalPlayerInfo.player_position)

func _physics_process(_delta):
	velocity = direction * movement_speed
	move_and_slide()


func _on_health_system_killed():
#	print(name + "killed")
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($Sprite2D)
	enemy_hit_player.play()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
