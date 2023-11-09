extends Node2D

var setpieces: Array = [
	preload("res://enemies/set_pieces/meteor_setpiece.tscn"),
	]


func _ready():
	EventManager.connect("difficulty_level_changed", spawn_at_difficulty)


func spawn_at_difficulty(difficulty_level):
	match difficulty_level:
		2:
			choose_set_piece()
		5:
			choose_set_piece()
		9:
			choose_set_piece()
		_:
			pass


func choose_set_piece():
	var chosen_set_piece = setpieces.pick_random()
	spawn_set_piece(chosen_set_piece)


func spawn_set_piece(set_peice_to_spawn):
	var set_piece_instance = set_peice_to_spawn.instantiate()
	add_child(set_piece_instance)
