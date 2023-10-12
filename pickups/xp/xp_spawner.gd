extends Node2D

var ExperienceScene = preload("res://pickups/xp/experience.tscn")

@onready var all_experience = %AllExperience

func _ready():
	EventManager.connect("enemy_destroyed", spawn_xp)

func spawn_xp(pos, _points):
	if randi_range(0,10) <= 4: return
	
	var xp = ExperienceScene.instantiate()
	xp.position = pos
	all_experience.call_deferred("add_child", xp)
