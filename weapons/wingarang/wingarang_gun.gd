extends Weapon

@export var max_bullets_on_screen = 1
@export var current_bullets_on_screen = 0

var Bullet: PackedScene = preload ("res://bullets/wingarang_bullet_new.tscn")

var bullet_speed = 150

@onready var bullet_spawn = $StartMarker
@onready var can_shoot_timer = $CantShootTimer


func _on_cant_shoot_timer_timeout():
	can_shoot = true
#	print("timer finished")


func shoot_bullet():
	if current_bullets_on_screen >= max_bullets_on_screen: return
	
	var _new_bullet = spawn_bullet(bullet_spawn)
	current_bullets_on_screen += 1
	_new_bullet.connect("tree_exited", wingarang_destroyed)
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


func wingarang_destroyed():
	current_bullets_on_screen -= 1


func upgrade():
	upgrade_number += 1
	match upgrade_number:
		2:
			print("level 2 Wingarang")
			max_bullets_on_screen += 1
			current_description = "2 Wingarangs"
		3:
			print("level 3 Wingarang")
			bullet_speed += 50
			current_description = "Wingarang Speed +"
		4:
			print("level 4 Wingarang")
			bullet_damage += 5
			current_description = "Wingarang Damage +"
		5:
			print("level 5 Wingarang")	
		_:
			print("Wingarang level outside of scope")
