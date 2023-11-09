extends Node2D

@export var current_obstacle_speed = 100
@export var chance_to_spawn_obstacle = 0.9
@export var chance_to_spawn_2_obstacle = 0.3
@export var obstacle_spawn_cooldown = 5

var obstacle_scene: PackedScene = preload("res://obstacles/meteor.tscn")
var min_x_spawn: float
var max_x_spawn: float

@onready var marker_min_x_spawn = $Markers/MarkerMinXSpawn
@onready var marker_max_x_spawn = $Markers/MarkerMaxXSpawn
@onready var creation_timer = $CreationTimer


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


func _on_creation_timer_timeout():
	if randf_range(0,1) <= chance_to_spawn_obstacle:
		create_obstacle()
		if randf_range(0,1) <= chance_to_spawn_2_obstacle:
			create_obstacle()
