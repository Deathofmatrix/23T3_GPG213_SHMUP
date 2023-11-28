class_name BossShotgun
extends Node2D

var Bullet = preload("res://enemies/enemy_bullets/turret_bullet.tscn")

var bullet_damage = 10
var bullet_colour

@export var can_shoot = true

@onready var bullet_spawns = $BulletSpawns
@onready var shoot_speed_timer = $BossShotTimer
@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D


func _process(_delta):
	if can_shoot:
#		print(can_shoot)
		shoot_bullet()


func _on_boss_shot_timer_timeout():
	can_shoot = true


func shoot_bullet():
#	print("shoot_bullet called")
	for spawn_point in bullet_spawns.get_children():
#		print("found children")
		spawn_bullet(spawn_point)
	audio_player.play()
	shoot_speed_timer.start()
	can_shoot = false


func spawn_bullet(spawn_point):

	var bullet = Bullet.instantiate() as Bullet
	bullet.position = spawn_point.position
	var temp_direction = Vector2.RIGHT
	bullet.direction = temp_direction.rotated(spawn_point.rotation)
	bullet.rotation = bullet.direction.angle()
	bullet.speed = 200
	bullet.bullet_damage = bullet_damage
	add_child(bullet)
	bullet.reparent(get_tree().current_scene)


	return bullet

func _on_boss_one_boss_defeated():
	queue_free()

