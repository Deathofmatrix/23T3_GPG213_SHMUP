class_name FollowEnemyMiniboss
extends Enemy

signal miniboss_killed()

enum STATE {FOLLOWING, WAITING, CHARGING}

var current_state = STATE.FOLLOWING
var direction = Vector2.ZERO
var future_player_direction = Vector2.ZERO

@export var movement_speed: int = 80
@export var charge_speed: int = 400

@onready var sprite_2d = $Sprite2D

func _process(_delta):
	direction = global_position.direction_to(GlobalPlayerInfo.player_position)
	if current_state == STATE.WAITING: return
	look_at(GlobalPlayerInfo.player_position)

func _physics_process(_delta):
	match current_state:
		STATE.FOLLOWING:
			follow_player()
			sprite_2d.modulate = Color.GOLDENROD
		STATE.WAITING:
			pause_before_charge()
			sprite_2d.modulate = Color.FIREBRICK
		STATE.CHARGING:
			charge_at_player()
			sprite_2d.modulate = Color.FIREBRICK
	
	move_and_slide()


func follow_player():
	velocity = direction * movement_speed


func pause_before_charge():
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	current_state = STATE.CHARGING


func charge_at_player():
	velocity = future_player_direction * charge_speed
	await get_tree().create_timer(0.7).timeout
	current_state = STATE.FOLLOWING


func _on_health_system_killed():
	emit_signal("miniboss_killed")
#	print(name + "killed")
	EventManager.emit_signal("enemy_destroyed", global_position, points)
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($Sprite2D)
	enemy_hit_player.play()


func _on_charge_cooldown_timeout():
	future_player_direction = global_position.direction_to(GlobalPlayerInfo.player.future_position)
	look_at(GlobalPlayerInfo.player.future_position)
	current_state = STATE.WAITING


func _on_visible_on_screen_notifier_2d_screen_entered():
	movement_speed = 80


func _on_visible_on_screen_notifier_2d_screen_exited():
	movement_speed = 300
