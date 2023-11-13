extends Node2D

@export var current_obstacle_speed = 100
@export var max_obstacles = 7
@export var obstacle_spawn_cooldown = 5.0

var obstacle_scene: PackedScene = preload("res://obstacles/meteor.tscn")
var min_x_spawn: float
var max_x_spawn: float
var last_obstacle = null


@onready var creation_timer = $ObstacleSpawner/CreationTimer
@onready var marker_min_x_spawn = $ObstacleSpawner/Markers/MarkerMinXSpawn
@onready var marker_max_x_spawn = $ObstacleSpawner/Markers/MarkerMaxXSpawn


func _ready():
	min_x_spawn = marker_min_x_spawn.position.x
	max_x_spawn = marker_max_x_spawn.position.x
	creation_timer.wait_time = obstacle_spawn_cooldown


func create_obstacle():
	var selected_position = Vector2(randf_range(min_x_spawn, max_x_spawn), 0)
	var obstacle = obstacle_scene.instantiate() as Meteor
	obstacle.position = selected_position
	obstacle.movement_speed = current_obstacle_speed
	add_child(obstacle)
	last_obstacle = obstacle


func destroy_setpiece():
	creation_timer.stop()
	await last_obstacle.tree_exiting
	queue_free()


func _on_creation_timer_timeout():
	for i in randi_range(5, max_obstacles):
		create_obstacle()
