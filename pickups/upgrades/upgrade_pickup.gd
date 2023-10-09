extends Area2D

var upgrades_on_screen: Array
var movement_speed

func _physics_process(delta):
	position += Vector2.DOWN * movement_speed * delta


func upgrade_collected():
	for upgrades in upgrades_on_screen:
		upgrades.queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
