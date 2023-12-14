extends Node

var difficulty_level: int = 1
var is_paused: bool = false

signal enemy_destroyed(global_position: Vector2, points: int)
signal player_leveled_up()
signal difficulty_level_changed(level: int)
signal wingarang_left_tree()
signal pause_for_setpiece(pause: bool)
signal boss_spawned()
signal boss_phase_two_entered()

#func _ready():
#	difficulty_level = 1

func reset_difficulty():
	difficulty_level = 1
	print("difficulty level is ", difficulty_level)

func increase_difficulty():
	difficulty_level += 1
	difficulty_level_changed.emit(difficulty_level)
