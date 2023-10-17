extends Weapon

var Bullet: PackedScene = preload ("res://bullets/wingarang_bullet.tscn")

var my_delta = 0
var can_shoot = true
var move_speed = 150

@onready var bullet_spawn = $Path2D
@onready var can_shoot_timer = $CantShootTimer

func _ready():
	weapon_name = "Wingarang"


func _process(_delta):
#	my_delta = delta
	shoot_bullet()
#	print (can_shoot)
#	print(can_shoot_timer.is_stopped())

func _physics_process(delta):
	$Path2D/PathFollow2D.progress += move_speed * delta
	if $Path2D/PathFollow2D.progress_ratio == 1:
		pass
#		if bullet:
#			bullet.queue_free()



func _on_cant_shoot_timer_timeout():
	can_shoot = true
	print("timer finished")


func shoot_bullet():
	if not can_shoot: return

	for spawn_point in bullet_spawn.get_children():
		var _new_bullet = spawn_bullet(spawn_point)
	
	can_shoot_timer.start()
	can_shoot = false


func spawn_bullet(spawn_point):
	var bullet = Bullet.instantiate() as Bullet
	bullet.position = spawn_point.position
#	$Path2D/PathFollow2D.add_child(bullet)
	$Path2D/PathFollow2D.call_deferred("add_child", bullet)
#	print("fired")
	


func upgrade():
	upgrade_number += 1
	match upgrade_number:
		2:
			print("level 2 Wingarang")
			bullet_damage += 10
			current_description = "Wingarang Damage ++"
		3:
			print("level 3 Wingarang")
			current_description = "Wingarang"
		4:
			print("level 4 Wingarang")
			bullet_damage += 5
			current_description = "Bullet Damage +"
		5:
			print("level 5 Wingarang")	
		_:
			print("Wingarang level outside of scope")
