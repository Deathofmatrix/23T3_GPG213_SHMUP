extends Control

signal score_increased(current_score)

@export var player_character: Player
@export var level: Level

var score = 0
var _current_max_health = 100
var _current_health = 100

@onready var score_text = %ScoreText
@onready var high_score_text = %HighScoreText
@onready var health_bar = %HealthBar
@onready var health_text = %HealthText

func _ready():
	_current_max_health = player_character.starting_max_health
	
	EventManager.connect("enemy_destroyed", _on_enemy_destroyed)
	score_text.text = "SCORE " + str(score)
	emit_signal("score_increased", score)
	update_health_bar()


func _on_enemy_destroyed(_pos, points):
	score += points
	score_text.text = "SCORE " + str(score)
	emit_signal("score_increased", score)
	high_score_text.text = "HIGHSCORE:\n" + str(level.level_parameters.high_score)
#	print(score)

func update_health_bar():
	health_bar.max_value = _current_max_health
	health_bar.value = _current_health
	
	health_text.text = str(_current_health, "/", _current_max_health)


func _on_player_player_health_updated(health):
	_current_health = health
	update_health_bar()


func _on_player_player_max_health_updated(max_health):
	_current_max_health = max_health
	update_health_bar()
