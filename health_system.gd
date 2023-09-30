extends Node2D

signal health_updated(health)
signal killed()

@export var max_health: int = 100 
@onready var health = max_health: set = _handle_health

# player can be damaged as fast as the game will update without this
@onready var invulnerability_timer = $InvulnerabilityTimer

# called from collision with bullet
# set the damage amount in bullet and deal damage to health
func handle_damage(amount):
	# print("hit player") # connection confirmed
	if invulnerability_timer.is_stopped():
	#	print("dealt damage") # connection confirmed
		invulnerability_timer.start()
		_handle_health(health - amount)

# called when health == 0
# presnetly nil functionality
func kill():
	print("killed")

# handles the player health
func _handle_health(value):
	# print("_handle_health called") # connection confirmed
	var prev_health = health
	health =clamp(value,0 , max_health)
	if health != prev_health:
		# print(health) #connection confirmed
		emit_signal("health_updated", health)
		if health <= 0:
			kill()
			emit_signal("killed") #incase anything else wants to know you're dead
