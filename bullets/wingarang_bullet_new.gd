extends Bullet

var timed_shot = true
var rotation_speed = 10

func _process(delta):
	$".".rotate(1 * rotation_speed * delta)


func _on_body_entered(body):
	var child_node = body.get_node_or_null("HealthSystem") 

	if child_node != null and child_node.has_method("handle_damage"):
		child_node.handle_damage(bullet_damage)



func _on_visible_on_screen_notifier_2d_screen_exited():
	
	direction.x = position.direction_to(GlobalPlayerInfo.player_position).x *2.5
	direction.y = position.direction_to(GlobalPlayerInfo.player_position).y *2.5

# this is incase it doesn't hit the clear box at the back of the player
func _on_lifespan_timer_timeout():
	queue_free()

# this is the preferred way of clearing the bullet
# it will look better and they will have slightly less screen time
func clear_weapon():
	queue_free()
