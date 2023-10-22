class_name Weapon
extends Node2D

@export var icon_image: Texture2D
@export var bullet_damage: int = 10
@export var upgrade_number: int = 1
@export var max_upgrades: int = 4
@export var weapon_name: String = ""
@export var weapon_description: String = ""
@export var shoot_sound: AudioStream

var can_shoot = true
var shoot_sound_player: AudioStreamPlayer2D
var current_description: String = ""

func _ready():
	current_description = weapon_description
	shoot_sound_player = AudioStreamPlayer2D.new()
	shoot_sound_player.stream = shoot_sound
	shoot_sound_player.bus = "SFX"
	add_child(shoot_sound_player)

func _process(_delta):
	if EventManager.is_paused: return
	request_shoot_bullet()


func request_shoot_bullet():
	if not can_shoot: return
	shoot_bullet()
	shoot_sound_player.play()

func shoot_bullet():
	pass


func check_if_can_upgrade():
	if upgrade_number >= max_upgrades:
		print("weapon max level")
		return false
	else:
		return true


func upgrade():
	print("haven't overridden upgrade func")
	pass
