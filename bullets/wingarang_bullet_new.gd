extends Bullet


var rotation_speed = 10

func _process(delta):
	$".".rotate(1 * rotation_speed * delta)

func _on_body_entered(body):
	var child_node = body.get_node_or_null("HealthSystem") 

	if child_node != null and child_node.has_method("handle_damage"):
		child_node.handle_damage(bullet_damage)


func _on_visible_on_screen_notifier_2d_screen_exited():
	direction.x = global_position.direction_to(GlobalPlayerInfo.player_position).x *2 
	direction.y = global_position.direction_to(GlobalPlayerInfo.player_position).y *2
