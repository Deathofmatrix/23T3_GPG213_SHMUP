class_name Level
extends Node2D

signal level_changed(level_name)
signal loading_level
signal level_loaded

var main_cam: Camera2D

@export var level_name: String = "level_name"


var level_parameters: Dictionary = {
	"current_score" : 0,
	"high_score" : 0,
	"tutorial_active" : true
}

func _ready():
	EventManager.reset_difficulty()
	EventManager.connect("pause_for_setpiece", play_pause_timer)


func _input(event):
	if event.is_action_pressed("increase_difficulty"):
		EventManager.increase_difficulty()

func play_loaded_sound():
	%LevelLoadedAudio.play()
#	%ChangeSceneButton.disabled = false
	get_tree().call_group("Change_Scene_Buttons", "set_disabled", false)
	EventManager.is_paused = false
	AudioServer.set_bus_effect_enabled(0, 0, false)
	emit_signal("level_loaded")


func load_level_parameters(new_level_parameters: Dictionary):
	level_parameters = new_level_parameters


func cleanup():
	if %BeginSceneChangeAudio.playing:
		await %BeginSceneChangeAudio.finished
	queue_free()


func load_level(level_to_change_to):
	emit_signal("level_changed", level_to_change_to)
	EventManager.is_paused = true


func handle_level_loading():
	emit_signal("loading_level")


func play_pause_timer(pause: bool):
	if $ScalingInfo/DifficultyScalingTimer != null:
		$ScalingInfo/DifficultyScalingTimer.paused = pause


func _on_button_pressed():
	%BeginSceneChangeAudio.play()
#	%ChangeSceneButton.disabled = true
	get_tree().call_group("Change_Scene_Buttons", "set_disabled", true)
	get_tree().paused = false
	if GlobalPlayerInfo.player != null:
		GlobalPlayerInfo.player.give_infinite_invulnerability()
	load_level(level_name)


func _on_hud_score_increased(score):
	level_parameters.current_score = score
	if level_parameters.high_score < score:
		level_parameters.high_score = score


func _on_player_player_killed():
	load_level("game_over")


func _on_difficulty_scaling_timer_timeout():
	EventManager.increase_difficulty()
	print("increase difficulty")


func _on_boss_one_boss_defeated():
	load_level("win_screen")


func _on_change_scene_button_pressed():
	_on_button_pressed()


func _on_restart_button_pressed():
	%BeginSceneChangeAudio.play()
	get_tree().call_group("Change_Scene_Buttons", "set_disabled", true)
	get_tree().paused = false
	if GlobalPlayerInfo.player != null:
		GlobalPlayerInfo.player.give_infinite_invulnerability()
	load_level("01")

func load_specific_level(name_of_level):
	%BeginSceneChangeAudio.play()
	get_tree().call_group("Change_Scene_Buttons", "set_disabled", true)
	get_tree().paused = false
	if GlobalPlayerInfo.player != null:
		GlobalPlayerInfo.player.give_infinite_invulnerability()
	load_level(name_of_level)

