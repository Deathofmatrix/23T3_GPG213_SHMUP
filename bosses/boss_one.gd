class_name BossOne
extends Enemy

signal requires_health_bar
signal boss_defeated

var can_move = false
var slide_speed = 50

@onready var health_system = $HealthSystem
@onready var boss_shotguns = $Phases/PhaseTwo

func _enemy_ready():
	emit_signal("requires_health_bar")


func _process(_delta):
	if  health_system.health <= 500:
		$StateChart.send_event("phase_two")


func _physics_process(delta):
	if can_move == true:
		position.x += slide_speed * delta


func _on_phase_two_state_entered():
	
	# needs optimisation
	
	$Phases/PhaseTwo/BossShotgun.can_shoot = true
	$Phases/PhaseTwo/BossShotgun2.can_shoot = true
	$Phases/PhaseTwo/BossShotgun3.can_shoot = true

	can_move = true



func _on_health_system_killed():
	destroy_enemy()


func _on_health_system_health_updated(_health, _was_damaged):
	hit_flash($BossSprite)
	enemy_hit_player.play()


func _on_right_screen_notifier_screen_exited():
	slide_speed *= -1


func _on_left_screen_notifier_screen_exited():
	slide_speed *= -1
