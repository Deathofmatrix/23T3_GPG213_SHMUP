class_name HealthSystem
extends Node2D

signal health_updated(health)
signal killed()

@export var max_health: int = 100 
@onready var health = max_health: set = _handle_health

var is_invulnerable = false

# player can be damaged as fast as the game will update without this
# will need to be tweeked further for enemies,
# as they should not have any invulnerability
@onready var invulnerability_timer = $InvulnerabilityTimer
@export var wait_time:float = 1.0
# called from collision with bullet
# set the damage amount in bullet and deal damage to health

func _ready():
	invulnerability_timer.wait_time = wait_time


func handle_damage(amount):
	# print("hit player") # connection confirmed
	if not is_invulnerable:
		is_invulnerable = true
	#	print("dealt damage") # connection confirmed
		invulnerability_timer.start()
		_handle_health(health - amount)

# called when health == 0
# presently nil functionality
func kill():
	print("killed")
	emit_signal("killed") #incase anything else wants to know you're dead
	get_parent().queue_free()


# handles the health of the node it's on
func _handle_health(value):
	# print("_handle_health called") # connection confirmed
	var prev_health = health
	health = clamp(value,0 , max_health)
	if health != prev_health:
#		print(health) #connection confirmed
		emit_signal("health_updated", health)
		if health <= 0:
			kill()


func _on_invulnerability_timer_timeout():
	is_invulnerable = false
