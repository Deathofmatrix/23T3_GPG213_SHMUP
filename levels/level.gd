class_name Level
extends Node2D

signal level_changed(level_name)

@export var level_name: String = "level_name"

var level_parameters: Dictionary = {
	"current_score" : 0,
	"high_score" : 0
}

func load_level_parameters(new_level_parameters: Dictionary):
	level_parameters = new_level_parameters


func cleanup():
	queue_free()


func load_level(level_to_change_to):
	emit_signal("level_changed", level_to_change_to)


func _on_button_pressed():
	load_level(level_name)


func _on_hud_score_increased(score):
	level_parameters.current_score = score
	if level_parameters.high_score < score:
			level_parameters.high_score = score


func _on_player_player_killed():
	load_level("game_over")

