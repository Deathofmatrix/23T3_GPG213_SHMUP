extends Weapon

var Bullet = preload("res://bullets/sword_bullet.tscn")

var bullet_lifetime = 0.2

@onready var bullet_spawns = $BulletSpawns
@onready var shoot_speed_timer = $ShootSpeedTimer


func _init():
	weapon_name = "WingSword"

func _on_shoot_speed_timer_timeout():
	can_shoot = true


func shoot_bullet():
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
	GlobalPlayerInfo.player.get_parent().add_child(bullet)
	return bullet

func upgrade():
	upgrade_number += 1
	match upgrade_number:
		2:
			print("level 2 wingsword")
			# change this to destroy incoming bullets from enemies
			shoot_speed_timer.wait_time = 1
			current_description = "Wingsword firerate ++"
		3:
			print("level 3 wingsword")
			bullet_damage += 10
			current_description = "Wingsword Damage ++"
		4:
			print("level 4 wingsword")
			bullet_lifetime += 1
			current_description = "Wingarang distance ++"
		_:
			print("wingsword level outside of scope")

