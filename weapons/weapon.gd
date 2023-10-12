class_name Weapon
extends Node2D

@export var icon_image: Texture2D
@export var bullet_damage: int = 10
@export var upgrade_number: int = 1
@export var max_upgrades: int = 4

var weapon_name: String = ""

func _process(_delta):
	shoot_bullet()
#	if Input.is_action_pressed("primary_action"):
#		shoot_bullet()

func shoot_bullet():
	pass


func check_if_can_upgrade():
	if upgrade_number >= max_upgrades:
		print("weapon max level")
		return false
	else:
		return true


func upgrade():
	print("haven't overridden upgrade func")
	pass
