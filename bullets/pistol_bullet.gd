extends Bullet


func _on_lifespan_timer_timeout():
	queue_free()
