extends VisibleOnScreenNotifier2D


func _on_screen_exited():
	get_parent().position.y -= 380
