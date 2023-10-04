class_name Meteor
extends CharacterBody2D

var movement_speed: int = 100
var points = 1000

func _process(_delta):
	var direction = Vector2(0,1)
	velocity = direction * movement_speed
	move_and_slide()

#
func _on_health_system_killed():
	print(name + "killed")
	EventManager.emit_signal("enemy_destroyed", global_position, points)


func _on_health_system_health_updated(_health):
	$Sprite2D.material.set("shader_parameter/enabled", false)
	await get_tree().create_timer(0.05).timeout
	$Sprite2D.material.set("shader_parameter/enabled", true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
