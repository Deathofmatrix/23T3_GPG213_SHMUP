extends Weapon

var Bullet = preload("res://bullets/pistol_bullet.tscn")

@onready var bullet_spawns = $BulletSpawns
@onready var shoot_speed_timer = $ShootSpeedTimer


func _init():
	weapon_name = "Pistol"


func _on_shoot_speed_timer_timeout():
	can_shoot = true


func shoot_bullet():
	for spawn_point in bullet_spawns.get_children():
		var _new_bullet = spawn_bullet(spawn_point)
	
	shoot_speed_timer.start()
	can_shoot = false


func spawn_bullet(spawn_point):
	var bullet = Bullet.instantiate() as Bullet
	bullet.position = spawn_point.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	bullet.bullet_damage = bullet_damage
	GlobalPlayerInfo.player.get_parent().add_child(bullet)
	return bullet


func upgrade():
	upgrade_number += 1
	match upgrade_number:
		2:
			print("level 2 pistol")
			bullet_damage += 5
			current_description = "Pistol Damage +"
		3:
			print("level 3 pistol")
			shoot_speed_timer.wait_time = 0.4
			current_description = "Fire Rate +"
		4:
			print("level 4 pistol")
			bullet_damage += 5
			shoot_speed_timer.wait_time = 0.3
			current_description = "Bullet Damage +\nFire Rate +"
		5:
			print("level 5 pistol")	
		_:
			print("pistol level outside of scope")
