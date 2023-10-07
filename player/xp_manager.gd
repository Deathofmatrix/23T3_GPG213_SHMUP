class_name XPManager
extends Node2D

signal leveled_up(xp_required)
signal xp_updated(current_xp)

# leveling system
@export var current_xp_level: int = 1

var current_xp: int = 0
var current_xp_total: int = 0
var current_xp_required: int = get_required_xp(current_xp_level + 1)


func get_required_xp(level):
	return round(pow(level, 1.8) + level * 4)

func gain_xp(amount):
	current_xp_total += amount
	current_xp += amount
	if current_xp >= current_xp_required:
		current_xp = 0
		level_up()
	emit_signal("xp_updated", current_xp)

func level_up():
	current_xp_level += 1
	current_xp_required = get_required_xp(current_xp_level)
	emit_signal("leveled_up", current_xp_required)
