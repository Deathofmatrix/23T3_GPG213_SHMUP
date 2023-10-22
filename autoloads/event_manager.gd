extends Node

var difficulty_level: int = 1
var is_paused: bool = false

signal enemy_destroyed(global_position: Vector2, points: int)
signal player_leveled_up()
signal difficulty_level_changed(level: int)

#func _ready():
#	difficulty_level = 1

func reset_difficulty():
	difficulty_level = 1
	print("difficulty level is ", difficulty_level)

func increase_difficulty():
	difficulty_level += 1
	difficulty_level_changed.emit(difficulty_level)
