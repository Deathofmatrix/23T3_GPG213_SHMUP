class_name Level
extends Node2D

signal level_changed(level_name)

@export var level_name: String = "level_name"

var level_parameters: Dictionary = {
	"current_score" : 0,
	"high_score" : 0
}

func _ready():
	EventManager.reset_difficulty()


func play_loaded_sound():
	%LevelLoadedAudio.play()
	%ChangeSceneButton.disabled = false
	EventManager.is_paused = false


func load_level_parameters(new_level_parameters: Dictionary):
	level_parameters = new_level_parameters


func cleanup():
	if %BeginSceneChangeAudio.playing:
		await %BeginSceneChangeAudio.finished
	queue_free()


func load_level(level_to_change_to):
	emit_signal("level_changed", level_to_change_to)
	EventManager.is_paused = true


func _on_button_pressed():
	%BeginSceneChangeAudio.play()
	%ChangeSceneButton.disabled = true
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
