extends Node2D

var current_setpiece
var health_upgrade = preload("res://weapons/default_health_upgrade.tscn")
var pickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")

@onready var warning_sound_player = $WarningSoundPlayer
@onready var looped_warning_player = $LoopedWarningPlayer
@onready var danger_flash = $DangerFlash
@onready var set_piece_timer = $SetPieceTimer

var setpieces: Array = [
	preload("res://enemies/set_pieces/meteor_setpiece.tscn"),
	]


func _ready():
	EventManager.connect("difficulty_level_changed", spawn_at_difficulty)


func spawn_at_difficulty(difficulty_level):
	match difficulty_level:
		2:
			choose_set_piece()
			player_warning()
		5:
			choose_set_piece()
			player_warning()
		9:
			choose_set_piece()
			player_warning()
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
