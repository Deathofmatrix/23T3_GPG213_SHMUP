extends Control

@onready var settings_window = $"../SettingsWindow"

func _ready():
	settings_window.hide()

func _on_settings_button_pressed():
	settings_window.show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_level_main_menu_loading_level():
	settings_window.hide()
