class_name BossOne
extends Enemy

var can_move = false
var slide_speed = 10

@onready var health_system = $HealthSystem
@onready var boss_shotguns = $Phases/PhaseTwo

func _process(_delta):
	if  health_system.health <= 500:
		$StateChart.send_event("phase_two")


func _physics_process(delta):
	if can_move == true:
		position.x += slide_speed * delta
	
		if global_position.x >= 100:
			slide_speed -= 1
		if global_position.x <= 0:
			slide_speed += 1


func _on_phase_two_state_entered():
	
	# needs optimisation
	
	$Phases/PhaseTwo/BossShotgun.can_shoot = true
	$Phases/PhaseTwo/BossShotgun2.can_shoot = true
	$Phases/PhaseTwo/BossShotgun3.can_shoot = true
	
	can_move = true


func _on_health_system_killed():
	destroy_enemy()
