extends Node2D

var current_setpiece
var health_upgrade = preload("res://weapons/default_health_upgrade.tscn")
var pickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")


@onready var warning_sound_player = $WarningSoundPlayer
@onready var looped_warning_player = $LoopedWarningPlayer
@onready var danger_flash = $DangerFlash
@onready var set_piece_timer = $SetPieceTimer
@onready var level_camera = $"../LevelOneCam"


var boss_fights: Array = [
	preload("res://bosses/boss_one.tscn")
]

var setpieces: Array = [
	preload("res://enemies/set_pieces/meteor_setpiece.tscn"),
	preload("res://enemies/set_pieces/speed_fall_setpiece.tscn")
	]


func _ready():

	randomize()
	EventManager.connect("difficulty_level_changed", spawn_at_difficulty)

func spawn_at_difficulty(difficulty_level):
	match difficulty_level:
		2:
#			enter_boss_fight()
			choose_set_piece()
			player_warning()
		4:
			choose_set_piece()
			player_warning()
		7:
			choose_set_piece()
			player_warning()
		9:
			enter_boss_fight()
			
		_:
			pass


func player_warning():
	warning_sound_player.play()
	looped_warning_player.play()
	flash_screen()


func flash_screen():
	danger_flash.show()
	await get_tree().create_timer(0.2).timeout
	danger_flash.hide()
	await get_tree().create_timer(0.2).timeout
	danger_flash.show()
	await get_tree().create_timer(0.2).timeout
	danger_flash.hide()
	await get_tree().create_timer(0.2).timeout
	danger_flash.show()
	await get_tree().create_timer(0.2).timeout
	danger_flash.hide()
	await get_tree().create_timer(0.2).timeout
	danger_flash.show()
	await get_tree().create_timer(0.2).timeout
	danger_flash.hide()

func choose_set_piece():
	var chosen_set_piece = setpieces.pick_random()
	spawn_set_piece(chosen_set_piece)
	set_piece_timer.start()


func spawn_set_piece(set_peice_to_spawn):
	var set_piece_instance = set_peice_to_spawn.instantiate()
	add_child(set_piece_instance)
	current_setpiece = set_piece_instance
	EventManager.pause_for_setpiece.emit(true)


func _on_set_piece_timer_timeout():
	current_setpiece.destroy_setpiece()
	EventManager.pause_for_setpiece.emit(false)
	looped_warning_player.stop()
	var health_instance = health_upgrade.instantiate()
	var pickup_instance = pickup.instantiate()
	pickup_instance.upgrade_type = health_instance
	pickup_instance.icon = health_instance.icon_image
	pickup_instance.upgrades_on_screen = [pickup_instance]
	pickup_instance.position = $HealthMarker.position
	add_child(pickup_instance)


# Boss Battle

func enter_boss_fight():
	var boss_fight_zoom = Vector2(0.5, 0.5)
	var tween = get_tree().create_tween()
	tween.tween_property(level_camera, "zoom", boss_fight_zoom, 2)
	
	var current_boss_fight = boss_fights[0].instantiate() 
	current_boss_fight.position = Vector2(250, -100)
	add_child(current_boss_fight)
	
	EventManager.pause_for_setpiece.emit(true)
	await get_tree().create_timer(20).timeout
	EventManager.pause_for_setpiece.emit(false)

