class_name Bullet
extends Area2D

@export var bullet_damage: int = 10
@export var speed = 200
@export var direction = Vector2.UP


func _physics_process(delta):
	position += direction * speed * delta

