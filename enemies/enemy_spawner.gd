extends Node2D

signal enemy_killed

const max_enemy_spawn_count = 7

@export var max_enemy_spawns = 2


var enemy_scenes: Array = [
	preload("res://enemies/follow_enemy.tscn"),
	preload("res://enemies/turret_enemy.tscn"),
	preload("res://enemies/speed_fall_enemy.tscn")]
var enemy_weights = [0, 0, 100]


var min_x_spawn: float
var max_x_spawn: float


@onready var marker_min_x_spawn = $Markers/MarkerMinXSpawn
@onready var marker_max_x_spawn = $Markers/MarkerMaxXSpawn
@onready var creation_timer = $CreationTimer

func _ready():
	EventManager.connect("difficulty_level_changed", update_difficulty)
	EventManager.connect("pause_for_setpiece", play_pause_timer)
	min_x_spawn = marker_min_x_spawn.position.x
	max_x_spawn = marker_max_x_spawn.position.x
	await get_tree().create_timer(1).timeout
	creation_timer.start()


func create_enemy(_enemy_index: int, _max_enemy_spawns: int):
	var min_enemy_spawns = _max_enemy_spawns - 3
	if max_enemy_spawns <= 3:
		min_enemy_spawns = 1
	for x in randi_range(min_enemy_spawns, _max_enemy_spawns):
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
			creation_timer.wait_time += .25 # 1.50
			enemy_weights = [0, 10, 90]
		3:
			max_enemy_spawns = 3
			creation_timer.wait_time -= 0.25 # 1.25
			enemy_weights = [5, 15, 80]
		4:
			max_enemy_spawns = 3
			creation_timer.wait_time += 0.25 # 1.50
			enemy_weights = [5, 25, 70]
		5: # first setpiece
			max_enemy_spawns = 4
			creation_timer.wait_time += 0.5 # 2.00
		6:
			max_enemy_spawns = 4
			creation_timer.wait_time -= 0.5 # 1.5
			enemy_weights = [15, 30, 60]
		7: # miniboss spawn
			max_enemy_spawns = 4
			creation_timer.wait_time += 0 # 1.5
		8:
			max_enemy_spawns = 5
			creation_timer.wait_time -= 0 # 1.5
		9: # second setpiece
			max_enemy_spawns = 6
			creation_timer.wait_time += 0.5 # 2.00
			enemy_weights = [30, 35, 35]
		10:
			max_enemy_spawns = max_enemy_spawn_count
			creation_timer.wait_time -= 0 # 2.00
			enemy_weights = [35, 35, 30]
		11: # boss spawn
			pass

func play_pause_timer(pause: bool):
	creation_timer.paused = pause


func _on_creation_timer_timeout():
	create_enemy(0, max_enemy_spawns)


func _on_set_piece_spawner_entered_boss_fight():
	max_x_spawn = $Node2D/NewMaxMarker.position.x
	min_x_spawn = $Node2D/NewMinMarker.position.x
