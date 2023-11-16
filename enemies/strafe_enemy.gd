class_name StrafeEnemy
extends Enemy


@export var Bullet = preload("res://enemies/enemy_bullets/turret_bullet.tscn")
@export var move_speed = 25
 

var target: Node2D = null

@onready var ray_cast = $AimingRaycast
@onready var reload_timer = $AimingRaycast/ShootingTimer
@onready var dodge_raycast = $DodgingRaycast


func _enemy_ready():
	target = find_player()
#	$AnimationPlayer.play("moving")


func _process(_delta):
#	if dodge_raycast.is_colliding() and dodge_raycast.get_collider().has_group("PlayerBullet"):
		detect_bullet()

func _physics_process(_delta):
	var direction = Vector2.DOWN
	velocity = direction * move_speed
	move_and_slide()
	
	
	if target != null:
		look_at(GlobalPlayerInfo.player_position)
		rotation_degrees = clamp(rotation_degrees, 0, 180)
	
		if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
			if reload_timer.is_stopped():
				shoot_at_player()
#				print("shot at player")


func shoot_at_player():
	ray_cast.enabled = false
	
	if Bullet:
		var bullet = Bullet.instantiate() as Bullet
#		print(bullet)
		bullet.bullet_damage = 15
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = ray_cast.global_rotation
	
	reload_timer.start()
#	$AnimationPlayer.play("moving")
#	$AnimationPlayer.queue("idle")


func find_player():
	var current_target: Node2D = null
	if get_tree().has_group("Player"):
		current_target = get_tree().get_nodes_in_group("Player")[0]
	return current_target


func _on_health_system_health_updated(_health, _was_damaged):
#	hit_flash($TurretEnemySprite)
	enemy_hit_player.play()


func _on_health_system_killed():
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	destroy_enemy()


func _on_timer_timeout():
		ray_cast.enabled = true

func detect_bullet():
#	var random_vector = Vector2(randf_range(1,-1), 0)
	var dodge_direction = Vector2.LEFT 
	velocity = dodge_direction * move_speed * 2
#	var detected_bullet: Node2D = null
	if get_tree().has_group("PlayerBullet"):
#		print("bullet detected")
		move_and_slide()



# if (physics.Raycast(other.transform.position, other.transform.forward * 100)
# print("found an object at + distance)

