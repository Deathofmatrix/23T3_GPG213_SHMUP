extends Control

@export var level: Level

func _ready():
	$TextureRect/Score.text = "SCORE\n" + str(level.level_parameters.current_score)
	$TextureRect/HighScore.text = "HIGHSCORE\n" + str(level.level_parameters.high_score)
