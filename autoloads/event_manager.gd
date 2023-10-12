extends Node

var difficulty_level: int = 1

signal enemy_destroyed(global_position: Vector2, points: int)
signal player_leveled_up()
signal difficulty_level_changed(level: int)

func increase_difficulty():
	difficulty_level += 1
	difficulty_level_changed.emit(difficulty_level)
