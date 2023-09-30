class_name Player
extends CharacterBody2D


@export var movement_data: MovementData
@export var weapons: Array[Weapon]
@onready var current_weapons = %CurrentWeapons
var Shotgun = preload("res://weapons/shotgun/shotgun.tscn")

func _ready():
	weapons.append(current_weapons.get_child(0))
	movement_data._testing()

func _process(_delta):
	if Input.is_action_just_pressed("secondary_action"):
		var shotgun = Shotgun.instantiate()
		add_weapon(shotgun)

func _physics_process(delta):
	
	var input_axis = Input.get_vector("left", "right", "up", "down")
	handle_acceleration(input_axis, delta)
	handle_air_resistance(input_axis, delta)
	move_and_slide()
	
	look_at(get_global_mouse_position())


func handle_acceleration(input_axis, delta):
	if input_axis != Vector2.ZERO:
		velocity = velocity.move_toward(input_axis * movement_data.max_speed, movement_data.acceleration * delta)


func handle_air_resistance(input_axis, delta):
	if input_axis == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, movement_data.friction * delta)

func check_weapon_duplicate(weapon: Weapon):
	for i in current_weapons.get_children():
		if i.weapon_name == weapon.weapon_name: 
			return true
	
	weapons.append(weapon)
	return false

func add_weapon(weapon: Weapon):
	print(check_weapon_duplicate(weapon))
	if check_weapon_duplicate(weapon): 
		weapon.queue_free()
	else:
		current_weapons.add_child(weapon)
	
