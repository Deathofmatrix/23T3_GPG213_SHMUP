extends CanvasLayer

@export var min_volume = -40
@export var max_volume = 6

@onready var fullscreen_button = %FullscreenButton
@onready var windowed_button = %WindowedButton
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var master_slider = %MasterSlider
@onready var back_button = %BackButton

var default_bus_layout = preload("res://default_bus_layout.tres")

func _ready():
	set_slider_values("Music", music_slider, -10)
	set_slider_values("SFX", sfx_slider, -9)
	set_slider_values("Master", master_slider, 0)


func set_slider_values(bus_name: String, slider_variable: Slider, start_value: float):
	slider_variable.min_value = min_volume
	slider_variable.max_value = max_volume
	
	var bus_index = AudioServer.get_bus_index(bus_name)
	slider_variable.value = AudioServer.get_bus_volume_db(bus_index)
#	slider_variable.value = start_value



func change_volume(bus, value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)
	if value <= min_volume:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), false)


func _input(event):
	if event.is_action_pressed("pause_button"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

func _on_back_button_pressed():
	hide()
	get_tree().paused = false

func _on_fullscreen_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_windowed_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_music_slider_value_changed(value):
	change_volume("Music", value)


func _on_sfx_slider_value_changed(value):
	change_volume("SFX", value)


func _on_master_slider_value_changed(value):
	change_volume("Master", value)


func _on_level_loading():
	hide()


func _on_sfx_slider_drag_started():
	$SFXTestPlayer.play()


func _on_sfx_slider_drag_ended(value_changed):
	$SFXTestPlayer.stop()
