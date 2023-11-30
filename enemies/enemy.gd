class_name Enemy
extends CharacterBody2D

@export var points = 100 
@export var damage = 10

@export var enemy_hit_sound: AudioStream = preload("res://enemies/audio/hit3.ogg")
@export var enemy_hit_player: AudioStreamPlayer2D

signal enemy_killed

func _ready():
	enemy_hit_player = AudioStreamPlayer2D.new()
	enemy_hit_player.stream = enemy_hit_sound
	enemy_hit_player.bus = "SFX"
	enemy_hit_player.volume_db = 0
	add_child(enemy_hit_player)
	add_to_group("enemy")
	_enemy_ready()


func _enemy_ready():
	pass


func hit_flash(sprite):
	sprite.material.set("shader_parameter/enabled", false)
	await get_tree().create_timer(0.05).timeout
	sprite.material.set("shader_parameter/enabled", true)

func destroy_enemy():
	if enemy_hit_player.playing:
		await enemy_hit_player.finished
		emit_signal("enemy_killed")
	queue_free()
