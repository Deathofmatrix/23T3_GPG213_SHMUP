class_name TurretEnemyMiniboss
extends Enemy

signal miniboss_killed()

@export var Bullet: PackedScene = null
@export var move_speed = 25
 
var target: Node2D = null
var clamp_left = 106
var clamp_right = 534
var moving_to_centre = false

@onready var ray_cast = $RayCast2D
@onready var reload_timer = $RayCast2D/ReloadTimer


func _enemy_ready():
	target = find_player()
	$AnimationPlayer.play("moving")


func _process(_delta):
	position = position.clamp(Vector2(clamp_left, position.y),  Vector2(clamp_right, position.y))
	is_at_edge_of_screen()
	if position.x >= clamp_right - clamp_left - 100 and position.x <= clamp_right - clamp_left + 100:
		print("not moving to centre")
		moving_to_centre = false


func _physics_process(_delta):
	if target != null:
		look_at(GlobalPlayerInfo.player_position)
#		rotation_degrees = clamp(rotation_degrees, 0, 180)
	
		if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
			if reload_timer.is_stopped():
				shoot_at_player()
	move_and_slide()


func shoot_at_player():
	ray_cast.enabled = false
	
	if Bullet:
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
		await get_tree().create_timer(0.2).timeout
		spawn_bullet()
	
	reload_timer.start()
	$AnimationPlayer.play("moving")
	$AnimationPlayer.queue("idle")


func spawn_bullet():
	var bullet = Bullet.instantiate() as Bullet
	bullet.bullet_damage = 15
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_rotation = ray_cast.global_rotation
	bullet.speed = 250


func find_player():
	var current_target: Node2D = null
	
	if get_tree().has_group("Player"):
		current_target = get_tree().get_nodes_in_group("Player")[0]
	
	return current_target


func move_to_centre(direction: int):
	print("exited Screen")
	moving_to_centre = true
	velocity.x = direction * move_speed


func is_at_edge_of_screen():
	if position.x == clamp_left:
		move_to_centre(1)
	if position.x == clamp_right:
		move_to_centre(-1)


func _on_reload_timer_timeout():
	ray_cast.enabled = true


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($TurretEnemySprite)
	enemy_hit_player.play()


func _on_health_system_killed():
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	emit_signal("miniboss_killed")
	destroy_enemy()


func _on_bullet_detection_area_entered(area):
	if moving_to_centre: return
	var direction_to_bullet = global_position.direction_to(area.global_position).x
	if direction_to_bullet < 0:
		velocity.x = floori(direction_to_bullet) * move_speed * -1
	if direction_to_bullet > 0:
		velocity.x = ceili(direction_to_bullet) * move_speed * -1
