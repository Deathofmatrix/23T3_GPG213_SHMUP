extends Node2D

var pickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")
var upgrades: Array = [
	preload("res://weapons/pistol/pistol.tscn"), 
	preload("res://weapons/shotgun/shotgun.tscn"), 
	preload("res://weapons/wingarang/wingarang_gun.tscn"), 
	preload("res://weapons/wingsword/wing_sword.tscn")
]

func destroy_setpiece():
	var tween = get_tree().create_tween()
	tween.tween_property($FollowEnemyMiniboss, "position", Vector2(360, 640), 3)
	await tween.finished
	queue_free()


func _on_follow_enemy_miniboss_enemy_killed():
	var upgrade_instance = upgrades.pick_random().instantiate()
	var pickup_instance = pickup.instantiate()
	pickup_instance.upgrade_type = upgrade_instance
	pickup_instance.icon = upgrade_instance.icon_image
	pickup_instance.upgrades_on_screen = [pickup_instance]
	pickup_instance.position = $UpgradeMarker.position
	add_child(pickup_instance)
