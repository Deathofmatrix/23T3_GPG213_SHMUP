extends Node2D

@export var current_obstacle_speed = 100

var obstacle_scene: PackedScene = preload("res://obstacles/obstacle.tscn")

func create_obstacle():
	var obstacle_start_pos = $Markers.get_children()
	var selected_position = obstacle_start_pos[randi() % obstacle_start_pos.size()]
	var obstacle = obstacle_scene.instantiate() as CharacterBody2D
	obstacle.position = selected_position.global_position
#	print(selected_position)
	add_child(obstacle)


func _on_creation_timer_timeout():
	create_obstacle()
