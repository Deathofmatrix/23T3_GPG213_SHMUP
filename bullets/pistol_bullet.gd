extends Bullet


func _on_lifespan_timer_timeout():
	queue_free()

# used to check that the body that the bullet hits has the required method
# 
func _on_body_entered(body):
	print("bullet hit player")
	var child_node = body.get_node("HealthSystem")
#
	if child_node == null:
		print("no child_node with 'HealthSystem'")
		return
#
	if child_node != null:
		if child_node.has_method("handle_damage"):
			print("got through 'if' check")
			# the if check is not preventing the rest of this function from being called
			# the 'return' check is also not stopping the rest of the method from being called
			child_node.handle_damage(10)
