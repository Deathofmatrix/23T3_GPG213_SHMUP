extends Node2D

signal miniboss_killed_early()

var pickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")

@onready var follow_enemy_miniboss = $FollowEnemyMiniboss


func destroy_setpiece():
	if follow_enemy_miniboss != null:
		var tween = get_tree().create_tween()
		tween.tween_property(follow_enemy_miniboss, "position", Vector2(360, 640), 3)
		await tween.finished
	queue_free()


func _on_follow_enemy_miniboss_enemy_killed():
	emit_signal("miniboss_killed_early")
