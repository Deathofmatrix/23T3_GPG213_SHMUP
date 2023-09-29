class_name Weapon
extends Node2D

var weapon_name: String = ""

func _process(_delta):
	if Input.is_action_pressed("primary_action"):
		shoot_bullet()

func shoot_bullet():
	pass
	
