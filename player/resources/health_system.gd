class_name HealthSystem
extends Node2D

signal health_updated(health, was_damaged: bool)
signal max_health_updated(max_health)
signal reached_low_health(is_low_health: bool)
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



func change_max_health(amount):
	if amount >= max_health:
		var new_health = health + amount - max_health
		max_health = amount
		health = new_health
	elif amount < max_health:
		max_health = amount
		if health > max_health:
			health = max_health
		print("changed Max Health to a lower value")
	max_health_updated.emit(max_health)

func handle_damage(amount):
	# print("hit player") # connection confirmed
	if not is_invulnerable:
		is_invulnerable = true
	#	print("dealt damage") # connection confirmed
		invulnerability_timer.start()
		_handle_health(health - amount)


func handle_heal(amount):
	_handle_health(health + amount)

func kill():
	emit_signal("killed") #incase anything else wants to know you're dead
#	get_parent().queue_free()


# handles the health of the node it's on
func _handle_health(value):
	var was_damaged: bool
	var prev_health = health
	health = clamp(value,0 , max_health)
	if health != prev_health:
		if health > prev_health: was_damaged = false
		if health < prev_health: was_damaged = true
#		print(health) #connection confirmed
		emit_signal("health_updated", health, was_damaged)
		if health <= 0:
			kill()
		elif health <= max_health / 5:
			emit_signal("reached_low_health", true)
		elif health > max_health / 5:
			emit_signal("reached_low_health", false)
		


func _on_invulnerability_timer_timeout():
	is_invulnerable = false
