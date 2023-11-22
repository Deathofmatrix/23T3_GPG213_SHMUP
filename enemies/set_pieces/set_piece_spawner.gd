extends Node2D

var current_setpiece
var health_upgrade = preload("res://weapons/default_health_upgrade.tscn")
var pickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")

@onready var warning_sound_player = $WarningSoundPlayer
@onready var looped_warning_player = $LoopedWarningPlayer
@onready var danger_flash = $DangerFlash
@onready var set_piece_timer = $SetPieceTimer
@onready var boss_spawn = $BossSpawn

var setpieces: Array = [
	preload("res://enemies/set_pieces/meteor_setpiece.tscn"),
	preload("res://enemies/set_pieces/speed_fall_setpiece.tscn")
	]

var minibosses: Array = [
	preload("res://enemies/set_pieces/follow_enemy_setpiece.tscn")
]

var boss_fights: Array = [
	preload("res://bosses/boss_one.tscn")
]


func _ready():
	randomize()
	EventManager.connect("difficulty_level_changed", spawn_at_difficulty)

func spawn_at_difficulty(difficulty_level):
	match difficulty_level:
		2:
			clear_screen("enemy")
			choose_set_piece(minibosses)
			player_warning()
		5:
			clear_screen("enemy")
			choose_set_piece(setpieces)
			player_warning()
		9:
			clear_screen("enemy")
			choose_set_piece(minibosses)
			player_warning()
		11:
			clear_screen("enemy")
			enter_boss_fight()
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

func choose_set_piece(array_to_choose_from: Array):
	var chosen_set_piece = array_to_choose_from.pick_random()
	spawn_set_piece(chosen_set_piece)
	set_piece_timer.start()


func spawn_set_piece(set_peice_to_spawn):
	var set_piece_instance = set_peice_to_spawn.instantiate()
	add_child(set_piece_instance)
	current_setpiece = set_piece_instance
	EventManager.pause_for_setpiece.emit(true)


func clear_screen(group_string: String):
	for node in get_tree().get_nodes_in_group(group_string):
		node.destroy_enemy()


func enter_boss_fight():
	var camera = get_parent().main_cam
	var boss_fight_zoom = Vector2(0.5, 0.5)
	var boss_fight_camera_movement = Vector2(0, 180)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(camera, "zoom", boss_fight_zoom, 2)
	tween.tween_property(camera, "position", camera.position + boss_fight_camera_movement, 2)
	EventManager.boss_spawned.emit()

	var current_boss_fight: BossOne = boss_fights[0].instantiate() 
	current_boss_fight.position = boss_spawn.position
	add_child(current_boss_fight)

	EventManager.pause_for_setpiece.emit(true)
	await get_tree().create_timer(20).timeout
	EventManager.pause_for_setpiece.emit(false)
	

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
