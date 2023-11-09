extends Node2D

func _ready():
	EventManager.connect("difficulty_level_changed", spawn_at_difficulty)


func spawn_at_difficulty(difficulty_level):
	match difficulty_level:
		4:
			spawn_setpiece()
		8:
			spawn_setpiece()
		_:
			pass


func spawn_setpiece():
	pass
