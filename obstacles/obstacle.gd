
extends CharacterBody2D

var movement_speed: int = 100

func _process(_delta):
	var direction = Vector2(0,1)
	velocity = direction * movement_speed
	move_and_slide()

#
#func _on_health_system_killed():
#	queue_free()
