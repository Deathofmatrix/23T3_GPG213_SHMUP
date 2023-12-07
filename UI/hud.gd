class_name HUD
extends Control

signal score_increased(current_score)

@export var player_character: Player
@export var level: Level
@export var upgrade_icon_slots: Array
@export var upgrade_level_labels: Array
@export var upgrade_backgrounds: Array
@export var difficulty_scaling_timer: Timer

var score = 0
var _current_max_health = 50
var _current_health = 50
var progression_notch = 0

@onready var score_text = %ScoreText
@onready var high_score_text = %HighScoreText
@onready var health_bar = %HealthBar
@onready var health_text = %HealthText
@onready var xp_bar = %XPBar
@onready var progress_bar = %ProgressBar
@onready var dialogue_text = %DialogueText
@onready var animation_player = $AnimationPlayer
@onready var on_player_healthbar = $OnPlayerHealthbar


func _ready():
	_current_max_health = player_character.starting_max_health
	
	initalise_upgrade_icons()
	EventManager.connect("enemy_destroyed", _on_enemy_destroyed)
	difficulty_scaling_timer.connect("timeout", increase_notch)
	progress_bar.max_value = difficulty_scaling_timer.wait_time * 10
	score_text.text = "SCORE:\n" + str(score)
	high_score_text.text = "HIGHSCORE:\n" + str(level.level_parameters.high_score)
	emit_signal("score_increased", score)
	update_health_bar()


func _input(event):
	if event.is_action_pressed("increase_difficulty"):
		progression_notch += 1

func _process(_delta):
	update_progression_bar()
	update_healthbar_location()


func initalise_upgrade_icons():
	upgrade_icon_slots = [%UpgradeIcon1, %UpgradeIcon2, %UpgradeIcon3, %UpgradeIcon4]
	upgrade_level_labels = [%UpgradeLevel1, %UpgradeLevel2, %UpgradeLevel3, %UpgradeLevel4]
	upgrade_backgrounds = [%UpgradeBackground1, %UpgradeBackground2, %UpgradeBackground3, %UpgradeBackground4]
	for background in upgrade_backgrounds:
		background.hide()


func update_health_bar():
	health_bar.max_value = _current_max_health
	health_bar.value = _current_health
	
	on_player_healthbar.max_value = _current_max_health
	on_player_healthbar.value = _current_health
	
	health_text.text = str(_current_health, "/", _current_max_health)


func update_upgrade_icons(upgrade_data):
	for icon in upgrade_icon_slots:
		if icon.texture:
			if icon.texture != upgrade_data.upgrade_icon: continue
		upgrade_backgrounds[upgrade_icon_slots.find(icon)].show()
		icon.texture = upgrade_data.upgrade_icon
		upgrade_level_labels[upgrade_icon_slots.find(icon)].text = str(upgrade_data.upgrade_level)
		return


func update_xp_bar(current_xp):
	xp_bar.value = current_xp


func update_max_xp(xp_required):
	xp_bar.value = 0
	xp_bar.max_value = xp_required


func update_healthbar_location():
	on_player_healthbar.position = GlobalPlayerInfo.player_position + Vector2(287, 205)
	if progression_notch >= 10:
		on_player_healthbar.position = GlobalPlayerInfo.player_position / 2 + Vector2(287, 105)


func _on_enemy_destroyed(_pos, points):
	score += points
	score_text.text = "SCORE:\n" + str(score)
	emit_signal("score_increased", score)
	high_score_text.text = "HIGHSCORE:\n" + str(level.level_parameters.high_score)


func update_progression_bar():
	var time_left_in_notch = difficulty_scaling_timer.wait_time - difficulty_scaling_timer.time_left
	progress_bar.value = (progression_notch * difficulty_scaling_timer.wait_time) + time_left_in_notch


func increase_notch():
	progression_notch += 1


func on_player_healthbar_change_visibility(is_opaque: bool):
	if is_opaque:
		on_player_healthbar.self_modulate = Color(Color.WHITE, 0.25)
	if not is_opaque:
		on_player_healthbar.self_modulate = Color(Color.WHITE, 1)


#Dialogue


func change_dialogue_text(text: String):
	dialogue_text.text = text


func animate_dog(do_start: bool):
	if do_start:
		animation_player.play("dog_talk")
	if not do_start:
		animation_player.stop()


#Signals


func _on_player_player_health_updated(health):
	_current_health = health
	update_health_bar()
	if on_player_healthbar.self_modulate == Color(Color.WHITE, 1): return
	on_player_healthbar_change_visibility(false)
	await get_tree().create_timer(1.9).timeout
	on_player_healthbar_change_visibility(true)


func _on_player_player_max_health_updated(max_health):
	_current_max_health = max_health
	update_health_bar()


func _on_player_upgrade_added_or_upgraded(weapon):
	var new_upgrade_data: UpgradeDataResource = UpgradeDataResource.new()
	new_upgrade_data.upgrade_level = weapon.upgrade_number
	new_upgrade_data.upgrade_icon = weapon.icon_image
	update_upgrade_icons(new_upgrade_data)
