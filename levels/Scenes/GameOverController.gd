extends Control

@export var level: Level

func _ready():
	%Score.text = "SCORE\n" + str(level.level_parameters.current_score)
	%HighScore.text = "HIGHSCORE\n" + str(level.level_parameters.high_score)
