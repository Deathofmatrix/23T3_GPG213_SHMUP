extends Node2D

@export var current_obstacle_speed = 100

var obstacle_scene: PackedScene = preload("res://obstacles/obstacle.tscn")
var obstacle_start_pos: Array

func _ready():
	obstacle_start_pos = %Markers.get_children()
	for i in %Markers.get_children():
		print (i.global_position)


func create_obstacle():

	var selected_position = obstacle_start_pos[randi() % obstacle_start_pos.size()]
	var obstacle = obstacle_scene.instantiate() as CharacterBody2D
	obstacle.position = selected_position.position
	print(selected_position.global_position)
	add_child(obstacle)


func _on_creation_timer_timeout():
	create_obstacle()
