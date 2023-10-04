extends Bullet


func _on_lifespan_timer_timeout():
	queue_free()

func _on_body_entered(body):
	queue_free()
	print("bullet hit obstacle")
	var child_node = body.get_node_or_null("HealthSystem") 
	#get_node_or_null()
	#Similar to get_node, but does not log an error if path does not point to a valid Node.

	if child_node != null and child_node.has_method("handle_damage"):
		child_node.handle_damage(10)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
