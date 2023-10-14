extends Weapon

var Bullet = preload("res://bullets/shotgun_bullet.tscn")

var can_shoot = true
var bullet_lifetime = 0.4

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
	var bullet = Bullet.instantiate() as Bullet
	bullet.position = spawn_point.global_position
	var temp_direction = (get_global_mouse_position() - global_position).normalized()
	bullet.direction = temp_direction.rotated(spawn_point.rotation)
	bullet.rotation = bullet.direction.angle()
	bullet.bullet_damage = bullet_damage
	bullet.bullet_lifetime = bullet_lifetime
#	get_tree().current_scene.add_child(bullet)
	GlobalPlayerInfo.player.get_parent().add_child(bullet)
	return bullet

func upgrade():
	upgrade_number += 1
	match upgrade_number:
		2:
			print("level 2 shotgun")
			shoot_speed_timer.wait_time = 1
			current_description = "Fire Rate +"
		3:
			print("level 3 shotgun")
			bullet_damage += 10
			current_description = "Shotgun Damage +"
		4:
			print("level 4 shotgun")
			bullet_lifetime += 0.2
			current_description = "Spread Size +"
		_:
			print("shotgun level outside of scope")
