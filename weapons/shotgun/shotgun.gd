extends Weapon

var Bullet = preload("res://bullets/shotgun_bullet.tscn")

var can_shoot = true

@onready var bullet_spawns = $BulletSpawns
@onready var shoot_speed_timer = $ShootSpeedTimer


func _init():
	weapon_name = "Shotgun"

func _on_shoot_speed_timer_timeout():
	can_shoot = true


func shoot_bullet():
	if not can_shoot: return
	for spawn_point in bullet_spawns.get_children():
		spawn_bullet(spawn_point)
	
	shoot_speed_timer.start()
	can_shoot = false


func spawn_bullet(spawn_point):
	var bullet = Bullet.instantiate() as Area2D
	bullet.position = spawn_point.global_position
	var temp_direction = (get_global_mouse_position() - global_position).normalized()
	bullet.direction = temp_direction.rotated(spawn_point.rotation)
	bullet.rotation = bullet.direction.angle()
	get_tree().current_scene.add_child(bullet)
	return bullet

func upgrade():
	upgrade_number += 1
	match upgrade_number:
		2:
			print("level 2 shotgun")
			shoot_speed_timer.wait_time = 1
		3:
			shoot_speed_timer.wait_time = 0.1
		4:
			pass
		5:
			pass
