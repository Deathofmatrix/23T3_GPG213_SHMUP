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
	if target != null:
#		print(target)
		look_at(GlobalPlayerInfo.player_position)
		rotation_degrees = clamp(rotation_degrees, 0, 180)
	
		if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
			if reload_timer.is_stopped():
				shoot_at_player()



func shoot_at_player():
#	print("Shot at player")
	ray_cast.enabled = false
	
	if Bullet:
		var bullet: Node2D = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = ray_cast.global_rotation
	
	reload_timer.start()


func find_player():
	var current_target: Node2D = null
	
	if get_tree().has_group("Player"):
		current_target = get_tree().get_nodes_in_group("Player")[0]
#		print("found player")
		
	return current_target

#func attack_player():
#	if is_in_position == true:
#		print("Now attacking player")
#		shoot_at_player()



func _on_reload_timer_timeout():
	ray_cast.enabled = true


func _on_health_system_health_updated(_health):
	hit_flash($Sprite2D)


func _on_health_system_killed():
	EventManager.emit_signal("enemy_destroyed", global_position, points)
