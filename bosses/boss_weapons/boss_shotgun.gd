class_name BossShotgun
extends Node2D

var Bullet = preload("res://enemies/enemy_bullets/turret_bullet.tscn")


var bullet_damage = 10

@export var can_shoot = false

@onready var bullet_spawns = $BulletSpawns
@onready var shoot_speed_timer = $BossShotTimer


func _process(_delta):
	if can_shoot == true:
#		print(can_shoot)
		shoot_bullet()


func _on_boss_shot_timer_timeout():
	can_shoot = true


func shoot_bullet():
#	print("shoot_bullet called")
	for spawn_point in bullet_spawns.get_children():
#		print("found children")
		spawn_bullet(spawn_point)
	shoot_speed_timer.start()
	can_shoot = false

func spawn_bullet(spawn_point):
	var bullet = Bullet.instantiate() as Bullet
	bullet.position = spawn_point.global_position
	var temp_direction = Vector2.DOWN.normalized()
	bullet.direction = temp_direction.rotated(spawn_point.rotation)
	bullet.rotation = bullet.direction.angle()
	bullet.bullet_damage = bullet_damage
	get_parent().add_child(bullet)
	return bullet

