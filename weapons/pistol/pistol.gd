extends Weapon

var Bullet = preload("res://bullets/pistol_bullet.tscn")

var can_shoot_backwards = false

@onready var bullet_spawns = $BulletSpawns
@onready var backward_bullet_spawn = $BackwardBulletSpawn
@onready var shoot_speed_timer = $ShootSpeedTimer


func _init():
	weapon_name = "Pistol"


func _on_shoot_speed_timer_timeout():
	can_shoot = true


func shoot_bullet():
	for spawn_point in bullet_spawns.get_children():
		var _new_bullet = spawn_bullet(spawn_point)
	if can_shoot_backwards:
		var _new_back_bullet = spawn_bullet(backward_bullet_spawn)
		_new_back_bullet.direction *= -1
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
			can_shoot_backwards = true
			current_description = "Backwards Bullet"
		4:
			print("level 4 pistol")
			shoot_speed_timer.wait_time = 0.3
			current_description = "Fire Rate +"
		5:
			print("level 5 pistol")	
			bullet_damage += 5
			current_description = "Pistol Damage +"
		6:
			shoot_speed_timer.wait_time = 0.2
			current_description = "Fire Rate +"
		7:
			bullet_damage += 5
			current_description = "Pistol Damage +"
		8:
			var spawnpoint = Marker2D.new()
			spawnpoint.position = Vector2(9, 0)
			bullet_spawns.add_child(spawnpoint)
			current_description = "Triple Bullet"
		_:
			print("pistol level outside of scope")
