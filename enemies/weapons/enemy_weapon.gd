extends Weapon

func spawn_bullet(_spawn_point):
	var bullet = Bullet.instantiate() as Bullet
	print(bullet)

