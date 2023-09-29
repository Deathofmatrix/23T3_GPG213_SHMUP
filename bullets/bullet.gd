class_name Bullet
extends Area2D

@export var speed = 200
var direction = Vector2.UP

func _physics_process(delta):
	position += direction * speed * delta
