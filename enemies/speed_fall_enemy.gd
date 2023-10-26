class_name SpeedFallEnemy
extends Enemy

@export var move_speed = 150 

func _physics_process(_delta):
	var direction = Vector2.DOWN
	velocity = direction * move_speed
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_health_system_killed():
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($Sprite2D)
