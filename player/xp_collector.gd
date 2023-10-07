class_name XPCollector
extends Area2D

signal xp_collected(value)

@export var xp_manager: XPManager

func _on_area_entered(area):
	area.is_collected = true
	await get_tree().create_timer(0.2).timeout
	area.queue_free()
#	emit_signal("xp_collected", area.xp_value)
	xp_manager.gain_xp(area.xp_value)
