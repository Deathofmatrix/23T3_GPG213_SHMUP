extends Node2D

signal miniboss_killed_early()

var minibosses_killed = 0

var pickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")

@onready var turret_enemy_miniboss = $TurretEnemyMiniboss
@onready var turret_enemy_miniboss_2 = $TurretEnemyMiniboss2


func _ready():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(turret_enemy_miniboss, "position", $Enemy1Spawn.position, 2)
	tween.tween_property(turret_enemy_miniboss_2, "position", $Enemy2Spawn.position, 2)


func destroy_setpiece():
	var tween = get_tree().create_tween().set_parallel()
	if turret_enemy_miniboss != null:
		tween.tween_property(turret_enemy_miniboss, "position", turret_enemy_miniboss.position + Vector2(0, 640), 5)
	if turret_enemy_miniboss_2 != null:
		tween.tween_property(turret_enemy_miniboss_2, "position", turret_enemy_miniboss_2.position + Vector2(0, 640), 5)
	if tween.is_running():
		await tween.finished
	queue_free()


func spawn_upgrade():
	emit_signal("miniboss_killed_early")


func _on_turret_enemy_miniboss_miniboss_killed():
	minibosses_killed += 1
	if minibosses_killed >= 2:
		spawn_upgrade()
