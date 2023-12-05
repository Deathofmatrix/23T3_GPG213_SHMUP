extends Node2D

@export var hud: HUD
@export var is_active = true

var is_restart_button_shown = false
var has_player_leveled_once = false
var is_first_upgrade = true
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
@onready var restart_tutorial_panel = $"../RestartTutorialPanel"
@onready var level_01 = $"../.."

func _ready():
	if not level_01.level_parameters.tutorial_active: 
		process_mode = Node.PROCESS_MODE_DISABLED
		is_active = false
		hud.change_dialogue_text("")
		return
	await get_parent().get_parent().level_loaded
	level_loaded = true
	EventManager.pause_for_setpiece.emit(true)
	display_dialogue()


#func _input(event):
#	if event.is_action_pressed("tutorial_skip"):
#		if is_tutorial_on_screen == false: return
#		skips += 1
#		is_tutorial_on_screen = false
#		hud.display_dialogue(false)
#		get_tree().paused = false
#		if skips != max_dialogue_number + 1: return
#		process_mode = Node.PROCESS_MODE_DISABLED
#		EventManager.pause_for_setpiece.emit(false)


func _process(_delta):
	if level_loaded == false: return
	if is_restart_button_shown == false: return
	get_tree().paused = true


func display_dialogue():
	if is_active == false: return
	if dialogue_number > max_dialogue_number: return
	hud.change_dialogue_text(dialogues[dialogue_number])
	dialogue_number += 1
	hud.animate_dog(true)


func _on_tutorial_enemy_enemy_killed():
	display_dialogue()


func _on_player_player_leveled_up():
	if has_player_leveled_once == true: return
	has_player_leveled_once = true
	await get_tree().create_timer(0.3).timeout
	display_dialogue()


func _on_popup_finished():
	if not is_first_upgrade: return
	is_first_upgrade = false
	display_dialogue()
	await get_tree().create_timer(2).timeout
	show_restart_button()


func show_restart_button():
	if is_active == false: return
	is_restart_button_shown = true
	restart_tutorial_panel.show()

func _on_area_2d_2_area_entered(area):
	area.global_position.y = area_2d.position.y


func _on_continue_button_pressed():
	is_restart_button_shown = false
	restart_tutorial_panel.hide()
	hud.change_dialogue_text("")
	get_tree().paused = false
	hud.animate_dog(false)
	process_mode = Node.PROCESS_MODE_DISABLED
	EventManager.pause_for_setpiece.emit(false)
	level_01.level_parameters.tutorial_active = false


func _on_restart_button_pressed():
	is_restart_button_shown = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS
