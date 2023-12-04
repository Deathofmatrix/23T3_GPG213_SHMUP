extends Node2D

signal warning_finished

@export var enemy_speed = 400
@export var max_spawns = 6
@export var min_spawns = 4

var speed_fall_enemy = preload("res://enemies/speed_fall_enemy.tscn")
var last_obstacle

@onready var markers = %Markers
@onready var creation_timer = $EnemySpawner/CreationTimer
@onready var spawn_sound = $SpawnSound

func ready():
	for i in randi_range(4, max_spawns):
		pick_spawn_pos()

func pick_spawn_pos():
	var spawn_pos = markers.get_children().pick_random()
	var dir = Vector2.LEFT
	var warning = spawn_pos.get_child(0)
	if warning.visible == false:
		warning.modulate = Color.WHITE
	warning.show()
	if spawn_pos.is_in_group("LeftSpawn"):
		dir = Vector2.RIGHT
	await get_tree().create_timer(1.5).timeout
	warning.modulate = Color.ORANGE
	warning.show()
	await get_tree().create_timer(1).timeout
	warning.hide()
	
	create_enemy(spawn_pos.position, dir)
	emit_signal("warning_finished")


func create_enemy(pos: Vector2, dir: Vector2):
	var selected_position = pos
	var enemy = speed_fall_enemy.instantiate() as Enemy
	enemy.max_health = 250
	last_obstacle = enemy
	enemy.position = selected_position
	enemy.direction = dir
	enemy.move_speed = enemy_speed
	if dir == Vector2.LEFT:
		enemy.rotation_degrees = 90
	else:
		enemy.rotation_degrees = -90
	add_child(enemy)
	last_obstacle = enemy


func destroy_setpiece():
	creation_timer.stop()
	await warning_finished
	await last_obstacle.tree_exited
	queue_free()

func _on_creation_timer_timeout():
	max_spawns += 0.5
	min_spawns += (1/3)
	spawn_sound.play()
	for i in randi_range(min_spawns, max_spawns):
		pick_spawn_pos()
