extends Node2D

@export var current_obstacle_speed = 200
@export var min_obstacles = 4
@export var max_obstacles = 4.75
@export var obstacle_spawn_cooldown = 1.0

var obstacle_scene: PackedScene = preload("res://obstacles/meteor.tscn")
var last_obstacle = null
var markers = null


@onready var creation_timer = $ObstacleSpawner/CreationTimer
@onready var markers_parent = %Markers
@onready var min_x_marker = %MinXMarker
@onready var max_x_marker = %MaxXMarker



func _ready():
	markers = markers_parent.get_children()
	creation_timer.wait_time = obstacle_spawn_cooldown


func create_obstacle(selected_position: Vector2):
	var obstacle = obstacle_scene.instantiate() as Meteor
	obstacle.position = selected_position
	obstacle.movement_speed = current_obstacle_speed
	add_child(obstacle)
	obstacle.add_to_group("SetPiece")
	last_obstacle = obstacle

func create_constant_meteors():
	create_obstacle(min_x_marker.position)
	create_obstacle(max_x_marker.position)


func destroy_setpiece():
	creation_timer.stop()
	await last_obstacle.tree_exiting
	queue_free()


func _on_creation_timer_timeout():
	min_obstacles += 0.2
	max_obstacles += 0.25
	print(str(min_obstacles) + " " + str(max_obstacles))
	var temp_markers: Array = markers.duplicate()
	var temp_position = Vector2.ZERO
	for i in randi_range(min_obstacles, max_obstacles):
		var index: int = randi_range(0, temp_markers.size() - 1)
		temp_position = temp_markers[index].position
		create_obstacle(temp_position)
		temp_markers.remove_at(index)
	
	create_constant_meteors()
