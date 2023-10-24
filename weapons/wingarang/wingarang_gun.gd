extends Weapon

var Bullet: PackedScene = preload ("res://bullets/wingarang_bullet_new.tscn")

var move_speed = 150

@onready var bullet_spawn = $StartMarker
@onready var can_shoot_timer = $CantShootTimer


#func _physics_process(delta):
#	$BoomerangPath/PathFollow2D.progress += move_speed * delta


func _on_cant_shoot_timer_timeout():
	can_shoot = true
#	print("timer finished")


func shoot_bullet():
	var _new_bullet = spawn_bullet(bullet_spawn)
	
	can_shoot_timer.start()
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
			print("level 2 Wingarang")
			bullet_damage += 10
			current_description = "Wingarang Damage ++"
		3:
			print("level 3 Wingarang")
			current_description = "Wingarang fast +"
			move_speed += 100
		4:
			print("level 4 Wingarang")
			bullet_damage += 20
			current_description = "Bullet Damage +"
		5:
			print("level 5 Wingarang")	
		_:
			print("Wingarang level outside of scope")
