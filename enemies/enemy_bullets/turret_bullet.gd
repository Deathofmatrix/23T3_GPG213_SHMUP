extends Bullet

var bullet_direction = Vector2.RIGHT


#func _process(_delta):
#	var last_position = GlobalPlayerInfo.player_position
#	bullet_direction.x = position.direction_to(last_position).x * 1.5

func _physics_process(delta):
	var movement = bullet_direction.rotated(rotation) * speed * delta
	global_position += movement

func _on_body_entered(body):
	queue_free()
	var child_node = body.get_node_or_null("HealthSystem") 

	if child_node != null and child_node.has_method("handle_damage"):
		child_node.handle_damage(bullet_damage)


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func bullet_blocked():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
