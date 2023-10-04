extends Control

@export var player_character: Player

var score = 0
var current_max_health = 100
var current_health = 100

@onready var score_text = %ScoreText
@onready var health_bar = %HealthBar
@onready var health_text = %HealthText

func _ready():
	EventManager.connect("enemy_destroyed", _on_enemy_destroyed)
	score_text.text = "SCORE " + str(score)
	update_health_bar()

func _on_enemy_destroyed(_pos, points):
	score += points
	score_text.text = "SCORE " + str(score)
#	print(score)

func update_health_bar():
	health_bar.max_value = current_max_health
	health_bar.value = current_health
	
	health_text.text = str(current_health, "/", current_max_health)


func _on_player_player_health_updated(health):
	current_health = health
	update_health_bar()


func _on_player_player_max_health_updated(max_health):
	current_max_health = max_health
	update_health_bar()
