extends Weapon

var Bullet = preload ("res://bullets/wingarang_bullet.tscn")

var my_delta = 0
var can_shoot = true
var move_speed = 150

@onready var bullet_spawn = $Path2D
@onready var can_shoot_timer = $CantShootTimer

func _ready():
	weapon_name = "Wingarang"
	shoot_bullet()

func _process(delta):
#	my_delta = delta
	$Path2D/PathFollow2D.progress += move_speed * delta


func _on_cant_shoot_timer_timeout():
	can_shoot = true


func shoot_bullet():	
	if not can_shoot: return

#	print(can_shoot)
	for spawn_point in bullet_spawn.get_children():
		var _new_bullet = spawn_bullet(spawn_point)
#		print("did shoot")

	can_shoot_timer.start()
	can_shoot = false


func spawn_bullet(spawn_point):
	var bullet = Bullet.instantiate() as Bullet
	bullet.position = spawn_point.position
#	$Path2D/PathFollow2D.add_child(bullet)
	$Path2D/PathFollow2D.call_deferred("add_child", bullet)
#	print("fired")


