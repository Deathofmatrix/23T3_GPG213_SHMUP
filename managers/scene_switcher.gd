extends Node


var next_level: Level

@onready var current_level = $MainMenu
@onready var animation_player = $AnimationPlayer
@onready var scene_switcher_cam = $SceneSwitcherCam


func _ready():
	current_level.connect("level_changed", handle_level_changed)
	current_level.play_loaded_sound()



func handle_level_changed(next_level_name: String):
#	var next_level_name: String
#
#	match current_level_name:
#		"main_menu":
#			next_level_name = "01"
#		"01":
#			next_level_name = "main_menu"
#		_:
#			print("invalid level name: " + current_level_name)
#			return
		
	next_level = load("res://levels/Scenes/level_" + next_level_name + ".tscn").instantiate()
	
	for child in next_level.get_children():
		if child.has_method("hide"):
			child.hide()
	
	call_deferred("add_child", next_level)
	animation_player.play("fade_to_black")
	next_level.connect("level_changed", handle_level_changed)
	transfer_data_between_scenes(current_level, next_level)
	


func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.load_level_parameters(old_scene.level_parameters)
	new_scene.main_cam = scene_switcher_cam

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_to_black":
			current_level.cleanup()
			current_level = next_level
			
			for child in current_level.get_children():
				if child.has_method("show"):
					child.show()
			
			next_level = null
			scene_switcher_cam.zoom = Vector2.ONE
			scene_switcher_cam.position = Vector2.ZERO
			animation_player.play("fade_from_black")
			current_level.handle_level_loading()
		"fade_from_black":
			current_level.play_loaded_sound()

