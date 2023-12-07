extends Control

@onready var settings_window = $"../SettingsWindow"

func _ready():
	settings_window.hide()
	if get_parent().level_parameters.tutorial_active == true:
		%TutorialButton.text = "tutorial is on"
	elif get_parent().level_parameters.tutorial_active == false:
		%TutorialButton.text = "tutorial is off"

func _on_settings_button_pressed():
	settings_window.show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_level_main_menu_loading_level():
	settings_window.hide()
	


func _on_tutorial_button_pressed():
	if get_parent().level_parameters.tutorial_active == true:
		get_parent().level_parameters.tutorial_active = false
		%TutorialButton.text = "tutorial is off"
	elif get_parent().level_parameters.tutorial_active == false:
		get_parent().level_parameters.tutorial_active = true
		%TutorialButton.text = "tutorial is on"
