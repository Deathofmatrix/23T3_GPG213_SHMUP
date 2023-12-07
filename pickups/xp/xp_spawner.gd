extends Node2D

@export var xp_sprites: Array = [
	"res://pickups/xp/XP_PickUp-2.png",
	"res://pickups/xp/XP_PickUp3.png",
	"res://pickups/xp/XP_PickUp4.png"
]

var ExperienceScene = preload("res://pickups/xp/experience.tscn")

@onready var all_experience = %AllExperience

func _ready():
	EventManager.connect("enemy_destroyed", spawn_xp)

func spawn_xp(pos, points):
#	if randi_range(1,10) <= 3: return
	
	var xp = ExperienceScene.instantiate()
	if points <= 100: xp.xp_value = 1
	elif points <= 150: 
		xp.xp_value = 3
		xp.change_sprite(xp_sprites[0])
	elif points <= 200: 
		xp.xp_value = 5
		xp.change_sprite(xp_sprites[1])
	elif points <= 1000: 
		xp.xp_value = 10
		xp.change_sprite(xp_sprites[2])
	xp.position = pos
	all_experience.call_deferred("add_child", xp)
