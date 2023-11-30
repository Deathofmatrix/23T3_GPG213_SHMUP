class_name FollowEnemy
extends Enemy

var direction = Vector2(0,1)

@onready var enemy_killed_particle = $enemy_killed_particle

@export var movement_speed: int = 50

func _process(_delta):
	direction.x = global_position.direction_to(GlobalPlayerInfo.player_position).x * 1.5
	look_at(GlobalPlayerInfo.player_position)

func _physics_process(_delta):
	velocity = direction * movement_speed
	move_and_slide()


func _on_health_system_killed():
#	print(name + "killed")
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	enemy_killed_particle.emitting = true
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($Sprite2D)
	enemy_hit_player.play()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
