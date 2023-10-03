extends Node2D

signal enemy_killed

@export var chance_to_spawn_enemy = 0.9
@export var chance_to_spawn_2_enemy = 0.3

var enemy_scenes: Array = [
	preload("res://enemies/follow_enemy.tscn")
	]
	
var min_x_spawn: float
var max_x_spawn: float

@onready var marker_min_x_spawn = $Markers/MarkerMinXSpawn
@onready var marker_max_x_spawn = $Markers/MarkerMaxXSpawn

func _ready():
	min_x_spawn = marker_min_x_spawn.position.x
	max_x_spawn = marker_max_x_spawn.position.x


func create_enemy(enemy_index: int):
	var selected_position = Vector2(randf_range(min_x_spawn, max_x_spawn), 0)
	var enemy = enemy_scenes[enemy_index].instantiate() as Enemy
	enemy.position = selected_position
	add_child(enemy)



func _on_creation_timer_timeout():
	if randf_range(0,1) <= chance_to_spawn_enemy:
		create_enemy(0)
		if randf_range(0,1) <= chance_to_spawn_2_enemy:
			create_enemy(0)
