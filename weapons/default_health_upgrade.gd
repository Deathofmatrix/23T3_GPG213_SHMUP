extends Weapon

var health_value = 1500

func _init():
	weapon_name = "Health"

func heal_player():
	return health_value
