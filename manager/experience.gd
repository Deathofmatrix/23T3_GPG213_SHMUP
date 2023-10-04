extends Area2D

@export var speed = 100
var direction = Vector2.DOWN
var is_collected = false

func _physics_process(delta):
	if is_collected:
		position = position.move_toward(GlobalPlayerInfo.player_position, speed * 5 * delta)
	else:
		position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
