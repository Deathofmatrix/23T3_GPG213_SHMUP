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
	"Thank you for your assistance, Human. We've evaded our captors, but one remains nearby. You must eliminate the approaching threat. - D0GB0T",
	"Commendations on defeating the minor foe. Ahead, an opportunity to assimilate their tech and fill your left tech bar for a ship upgrade. - D0GB0T",
	"Your tech collection proficiency pays off, human. A ship upgrade awaits. Upgrades remain hidden until picked up; check the screen for the computer's analysis. - D0GB0T",
	"Admirable choice, human. With the upgrade secured, my focus shifts to crafting new tech for our journey. Your decisions shape our destiny; may they lead us to triumph. - D0GB0T"
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
#	if is_tutorial_on_screen == false: return
#	get_tree().paused = true


func display_dialogue():
	if dialogue_number > max_dialogue_number: return
	is_tutorial_on_screen = true
	hud.change_dialogue_text(dialogues[dialogue_number])
#	hud.display_dialogue(true)
	dialogue_number += 1


func _on_tutorial_enemy_enemy_killed():
	print("tut enemy killed")
	display_dialogue()


func _on_player_player_leveled_up():
	if has_player_leveled_once == true: return
	has_player_leveled_once = true
	await get_tree().create_timer(0.3).timeout
	display_dialogue()


func _on_popup_finished():
	player_upgrades += 1
	if player_upgrades >= 3: return
	if player_upgrades == 1: return
	await get_tree().create_timer(0.4).timeout
	display_dialogue()


func _on_area_2d_2_area_entered(area):
	area.global_position.y = area_2d.position.y
