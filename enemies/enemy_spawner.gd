extends Node2D

signal enemy_killed

@export var max_enemy_spawns = 1

var enemy_scenes: Array = [
	preload("res://enemies/follow_enemy.tscn"),
	preload("res://enemies/turret_enemy.tscn")]

var min_x_spawn: float
var max_x_spawn: float


@onready var marker_min_x_spawn = $Markers/MarkerMinXSpawn
@onready var marker_max_x_spawn = $Markers/MarkerMaxXSpawn

func _ready():
	EventManager.connect("difficulty_level_changed", update_difficulty)
	min_x_spawn = marker_min_x_spawn.position.x
	max_x_spawn = marker_max_x_spawn.position.x


func create_enemy(_enemy_index: int, _max_enemy_spawns: int):
	for x in randi_range(0, _max_enemy_spawns):
		var selected_position = Vector2(randf_range(min_x_spawn, max_x_spawn), 0)
		var selected_enemy_scene = enemy_scenes.pick_random()
#		if selected_enemy_scene == enemy_scenes[1]:
		var enemy = selected_enemy_scene.instantiate() as Enemy
		enemy.position = selected_position
		add_child(enemy)


func update_difficulty(difficulty_level: int):
	print("difficulty level: " + str(difficulty_level))
	match difficulty_level:
		2:
			max_enemy_spawns = 2
		3:
			max_enemy_spawns = 3
		4:
			max_enemy_spawns = 5
		5:
			max_enemy_spawns = 8
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass


func _on_creation_timer_timeout():
	create_enemy(0, max_enemy_spawns)
