class_name Enemy
extends CharacterBody2D

@export var points = 100 
@export var damage = 10

signal enemy_killed

func hit_flash(sprite):
	sprite.material.set("shader_parameter/enabled", false)
	await get_tree().create_timer(0.05).timeout
	sprite.material.set("shader_parameter/enabled", true)
