extends Node2D

signal enemy_killed

const max_enemy_spawn_count = 5

@export var max_enemy_spawns = 1


var enemy_scenes: Array = [
	preload("res://enemies/follow_enemy.tscn"),
	preload("res://enemies/turret_enemy.tscn"),
	preload("res://enemies/speed_fall_enemy.tscn")]
var enemy_weights = [35, 15, 50]


var min_x_spawn: float
var max_x_spawn: float


@onready var marker_min_x_spawn = $Markers/MarkerMinXSpawn
@onready var marker_max_x_spawn = $Markers/MarkerMaxXSpawn

func _ready():
	EventManager.connect("difficulty_level_changed", update_difficulty)
	min_x_spawn = marker_min_x_spawn.position.x
	max_x_spawn = marker_max_x_spawn.position.x


func create_enemy(_enemy_index: int, _max_enemy_spawns: int):
	for x in randi_range(1, _max_enemy_spawns):
		var selected_position = Vector2(randf_range(min_x_spawn, max_x_spawn), 0)
		var selected_enemy_scene = weighted_spawn_chance()
		var enemy = selected_enemy_scene.instantiate() as Enemy
		enemy.position = selected_position
		add_child(enemy)


func weighted_spawn_chance():
	var total_weight = 0
	for weight in enemy_weights:
		total_weight += weight
	
	var random_value = randi() % total_weight
	var cumulative_weight = 0
	
	for i in range(enemy_weights.size()):
		cumulative_weight += enemy_weights[i]
		if random_value < cumulative_weight:
			return enemy_scenes[i]
	
	return enemy_scenes[enemy_weights.size() - 1]



func update_difficulty(difficulty_level: int):
	print("difficulty level: " + str(difficulty_level))
	match difficulty_level:
		2:
			max_enemy_spawns = 2
			$CreationTimer.wait_time += .25 # 1.50
		3:
			max_enemy_spawns = 3
			$CreationTimer.wait_time += .5 # 2.00
		4:
			max_enemy_spawns = 4
			$CreationTimer.wait_time += .25 # 2.25
		5:
			max_enemy_spawns = 5
			$CreationTimer.wait_time += .25 # 2.50
		6:
			max_enemy_spawns = max_enemy_spawn_count


func _on_creation_timer_timeout():
	create_enemy(0, max_enemy_spawns)
