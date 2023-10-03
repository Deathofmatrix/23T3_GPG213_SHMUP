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
