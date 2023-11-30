extends Node2D

@export var hud: HUD

var is_tutorial_on_screen = true
var has_player_leveled_once = false
var player_upgrades = 0
var level_loaded = false
var dialogue_number = 0
var max_dialogue_number = 3
var dialogues: Array = [
	"premable",
	"XP",
	"upgrade",
	"final warning"
]

@onready var tutorial_enemy = $"../../TutorialEnemy"

func _ready():
	await get_parent().get_parent().level_loaded
	level_loaded = true
	display_dialogue()


func _input(event):
	if event.is_action_pressed("tutorial_skip"):
		is_tutorial_on_screen = false
		hud.display_dialogue(false)
		get_tree().paused = false


func _process(_delta):
	if level_loaded == false: return
	EventManager.pause_for_setpiece.emit(true)
	if is_tutorial_on_screen == false: return
	get_tree().paused = true


func display_dialogue():
	if dialogue_number == max_dialogue_number: return
	is_tutorial_on_screen = true
	hud.change_dialogue_text(dialogues[dialogue_number] + "\n-Press Space To Continue-")
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
	await get_tree().create_timer(0.3).timeout
	display_dialogue()
