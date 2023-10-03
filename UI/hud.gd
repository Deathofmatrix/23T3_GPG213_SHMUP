extends Control

var score = 0

func _ready():
	EventManager.connect("enemy_destroyed", _on_enemy_destroyed)
	$Score.text = "SCORE " + str(score)

func _on_enemy_destroyed(_pos, points):
	score += points
	$Score.text = "SCORE " + str(score)
	print(score)
