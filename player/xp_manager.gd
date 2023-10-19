class_name XPManager
extends Node2D

signal leveled_up(xp_required, level)
signal xp_updated(current_xp)

# leveling system
@export var current_xp_level: int = 1

var current_xp: int = 0
var current_xp_total: int = 0
var current_xp_required: int = get_required_xp(current_xp_level + 1)

#func _ready():
#	print (current_xp_required) 
# the required xp for the first level is 11

func _process(_delta):
	if Input.is_action_just_pressed("dev_action"):
		level_up()

func get_required_xp(level):
	if current_xp_level <= 1:
		current_xp = 10
		# a little hack that needs fixing 
		# this is here just to ensure that the first 
		# XP pick_up results in an upgrade for the player
	
	return round(pow(level, 1.5) + level * 4)


func gain_xp(amount):
	current_xp_total += amount
	current_xp += amount
	emit_signal("xp_updated", current_xp)
	if current_xp >= current_xp_required:
		current_xp = 0
		level_up()


func level_up():
	current_xp_level += 1
	current_xp_required = get_required_xp(current_xp_level)
	emit_signal("leveled_up", current_xp_required, current_xp_level)
	EventManager.player_leveled_up.emit()
