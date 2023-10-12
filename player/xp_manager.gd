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

func get_required_xp(level):
	return round(pow(level, 1.2) + level * 7)


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
