class_name TurretEnemy
extends Enemy

@export var Bullet: PackedScene = null
@export var points = 175
@export var move_speed = 25

var target: Node2D = null

var my_delta = 0

var distance_moved = 0
#var position_moved_to: Vector2
#var is_in_position = false


@onready var ray_cast = $RayCast2D
@onready var reload_timer = $RayCast2D/ReloadTimer

func _ready():
	target = find_player()
#	position_moved_to = randi_range(-140, -75)

#func _process(delta):
#	if distance_moved < 100:
#		var new_position = global_position + Vector2(0, move_speed * delta)
#		var position_moved_to = position.y
#		if new_position.y > -140:
#			new_position.y = -140
#		global_position = new_position
#		distance_moved = global_position.y
#
#		if new_position.y == -140:
#			is_in_position = true

func _physics_process(_delta):
	var direction = Vector2.DOWN
	velocity = direction * move_speed
	move_and_slide()
	
	if target != null:
#		print(target)
		look_at(GlobalPlayerInfo.player_position)
		rotation_degrees = clamp(rotation_degrees, 0, 180)
	
		if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
			if reload_timer.is_stopped():
				shoot_at_player()



func shoot_at_player():
#	print("Shot at player")
	ray_cast.enabled = false
	
	if Bullet:
		var bullet: Node2D = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = ray_cast.global_rotation
	
	reload_timer.start()


func find_player():
	var current_target: Node2D = null
	
	if get_tree().has_group("Player"):
		current_target = get_tree().get_nodes_in_group("Player")[0]
#		print("found player")
		
	return current_target

#func attack_player():
#	if is_in_position == true:
#		print("Now attacking player")
#		shoot_at_player()



func _on_reload_timer_timeout():
	ray_cast.enabled = true


func _on_health_system_health_updated(_health):
	pass
#	hit_flash($Sprite2D)


func _on_health_system_killed():
	EventManager.emit_signal("enemy_destroyed", global_position, points)
