extends Node2D

@export var hud: HUD

var is_tutorial_on_screen = true
var has_player_leveled_once = false
var player_upgrades = 0
var level_loaded = false
var dialogue_number = 0
var skips = 0
var max_dialogue_number = 3
var dialogues: Array = [
	"Grateful for your assistance, human. We've eluded our corrupt captors, but one of them lurks ahead. Stay alert; our journey to safety depends on you. You must destroy the enemy.",
	"Commendations for your victory over the minor foe, human. Ahead lies an opportunity to assimilate their technology for a ship upgrade. This piece will fill your tech bar on the right so you can upgrade your ship.",
	"Your proficiency in collecting technology has borne fruit, human. A ship upgrade awaits. Approach it and choose wisely from the available enhancements. The upgrades will be hidden until you pick them up, then refer to the top right corner of your hud for the computer's analysis.",
	"Admirable choice, human. With the upgrade secured, my attention turns to crafting new technology for our journey. Your decisions shape our destiny; may they lead us to triumph."
]

@onready var tutorial_enemy = $"../../TutorialEnemy"
@onready var area_2d = $Area2D
@onready var area_2d_2 = $Area2D2

func _ready():
	await get_parent().get_parent().level_loaded
	level_loaded = true
	display_dialogue()


func _input(event):
	if event.is_action_pressed("tutorial_skip"):
		if is_tutorial_on_screen == false: return
		skips += 1
		is_tutorial_on_screen = false
		hud.display_dialogue(false)
		get_tree().paused = false
		if skips != max_dialogue_number + 1: return
		process_mode = Node.PROCESS_MODE_DISABLED
		EventManager.pause_for_setpiece.emit(false)


func _process(_delta):
	if level_loaded == false: return
	EventManager.pause_for_setpiece.emit(true)
	if is_tutorial_on_screen == false: return
	get_tree().paused = true


func display_dialogue():
	if dialogue_number > max_dialogue_number: return
	is_tutorial_on_screen = true
	hud.change_dialogue_text(dialogues[dialogue_number] + "\n[PRESS SPACEBAR]")
	hud.display_dialogue(true)
	dialogue_number += 1


func _on_tutorial_enemy_enemy_killed():
	print("tut enemy killed")
	display_dialogue()


func _on_player_player_leveled_up():
	if has_player_leveled_once == true: return
	has_player_leveled_once = true
	await get_tree().create_timer(0.3).timeout
	display_dialogue()


func _on_player_upgrade_added_or_upgraded(_weapon):
	player_upgrades += 1
	if player_upgrades >= 3: return
	if player_upgrades == 1: return
	await get_tree().create_timer(0.4).timeout
	display_dialogue()


func _on_area_2d_2_area_entered(area):
	area.global_position.y = area_2d.position.y
