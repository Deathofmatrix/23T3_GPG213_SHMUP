class_name BossOne
extends Enemy

signal requires_health_bar
signal boss_defeated

var can_move = false
var shotgun_timers = []
var shotgun_animators = []
var can_shotgun_shoot = []
var turret_fire_rate = []

@export var slide_speed = 250

@onready var health_system = $HealthSystem

func _enemy_ready():
#	for i in range(1, 4):
#		var path = "Phases/PhaseTwo/BossShotgun" + str(i) + "/BossShotTimer"
#		var timer_node = get_node(path)
#		print("Path:", path)
#		print("Timer Node:", timer_node)
#
#	for i in range(1,5):
#		var reload_timer_nodes = get_node("Phases/PhaseOne/Turret" + str(i) + "/RayCast2D/ReloadTimer")
#		turret_fire_rate.append(reload_timer_nodes)
#
#	for fire_rate in turret_fire_rate:
#		fire_rate.wait_time = 1
	
	emit_signal("requires_health_bar")


func _process(_delta):
	
	if health_system.health <= health_system.max_health /3:
		$StateChart.send_event("phase_three")
	
	elif health_system.health <= health_system.max_health /1.5:
		$StateChart.send_event("phase_two")


func _physics_process(delta):
	if can_move == true:
		position.x += slide_speed * delta
	
		if global_position.x >= 100:
			slide_speed -= 1
		if global_position.x <= 0:
			slide_speed += 1


# Phases

func _on_phase_two_state_entered():
	for i in range(1, 4):
		var shotgun_nodes = get_node("Phases/PhaseTwo/BossShotgun" + str(i))
		can_shotgun_shoot.append(shotgun_nodes)
	
	for shotguns in can_shotgun_shoot:
		shotguns.can_shoot = true
	
	can_move = true


func _on_phase_three_state_entered():
	for i in range(1, 4):
		var shotgun_timer_node = get_node("Phases/PhaseTwo/BossShotgun" + str(i) + "/BossShotTimer")
		shotgun_timers.append(shotgun_timer_node)
	
	for timer in shotgun_timers:
		timer.wait_time = .8
	
	for i in range(1,4):
		var animator_player = get_node("Phases/PhaseTwo/BossShotgun" + str(i) + "/AnimationPlayer")
		shotgun_animators.append(animator_player)
	
	for animators in shotgun_animators:
		animators.play("phase_three_anim")
	
	EventManager.pause_for_setpiece.emit(false)


# Signals

func _on_health_system_killed():
	$"../../..".handle_level_changed("win_screen")
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($BossSprite)
	enemy_hit_player.play()

