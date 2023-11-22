class_name FollowEnemyMiniboss
extends Enemy

enum STATE {FOLLOWING, CHARGING}

var current_state = STATE.FOLLOWING
var direction = Vector2.ZERO
var last_player_direction = Vector2.ZERO

@export var movement_speed: int = 50
@export var charge_speed: int = 250

func _process(_delta):
	direction = global_position.direction_to(GlobalPlayerInfo.player_position)
	look_at(GlobalPlayerInfo.player_position)

func _physics_process(_delta):
	match current_state:
		STATE.FOLLOWING:
			follow_player()
		STATE.CHARGING:
			charge_at_player()
	
	move_and_slide()


func follow_player():
	print("following")
	velocity = direction * movement_speed


func charge_at_player():
	print("charging")
	velocity = last_player_direction * charge_speed
	await get_tree().create_timer(1).timeout
	current_state = STATE.FOLLOWING


func _on_health_system_killed():
#	print(name + "killed")
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($Sprite2D)
	enemy_hit_player.play()


func _on_charge_cooldown_timeout():
	last_player_direction = direction
	current_state = STATE.CHARGING


func _on_visible_on_screen_notifier_2d_screen_entered():
	movement_speed = 50


func _on_visible_on_screen_notifier_2d_screen_exited():
	movement_speed = 200
