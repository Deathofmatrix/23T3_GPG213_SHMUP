class_name TurretEnemy
extends Enemy

var move_speed = 100
var distance_moved = 0


func _process(delta):
	if distance_moved < 100:
		var new_position = position + Vector2(0, move_speed * delta)
		if new_position.y > 100:
			new_position.y = 100
		position = new_position
		distance_moved = position.y

	if position.y >= 100:
		attack_player()


func attack_player():
	print("Now attacking player")
	look_at(GlobalPlayerInfo.player_position)
	
	# find the position of the player
	# shoot at the player
	# repeat
