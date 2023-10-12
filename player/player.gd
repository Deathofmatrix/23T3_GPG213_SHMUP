class_name Player
extends CharacterBody2D

signal player_health_updated(health)
signal player_max_health_updated(max_health)
signal player_killed

@export var health_system: HealthSystem
@export var hud: HUD
@export var movement_data: MovementData
@export var weapons: Array[Weapon]
@export var starting_max_health = 100

@export var current_level = 1
@export var current_xp = 1
@export var current_xp_required = 1

var screen_half_height: int = 180
var screen_half_width: int = 224

var Shotgun = preload("res://weapons/shotgun/shotgun.tscn")

@onready var animation_player = $AnimationPlayer
@onready var current_weapons = %CurrentWeapons


func _ready():
	weapons.append(current_weapons.get_child(0))
	GlobalPlayerInfo.player = self
	health_system.change_max_health(starting_max_health)

func _process(_delta):
	GlobalPlayerInfo.player_position = global_position
	lock_player_to_screen()
	give_invulnerability()
#	if Input.is_action_just_pressed("secondary_action"):
#		health_system.change_max_health(200)
#	if Input.is_action_just_pressed("primary_action"):
#		health_system.change_max_health(100)

func _physics_process(delta):
	
	var input_axis = Input.get_vector("left", "right", "up", "down")
	handle_acceleration(input_axis, delta)
	handle_air_resistance(input_axis, delta)
	move_and_slide()
	
	look_at(get_global_mouse_position())


# Movement


func lock_player_to_screen():
	var viewport_pos = get_viewport_rect().position
	var top_left = viewport_pos - Vector2(screen_half_width, screen_half_height)
	var bottom_right = viewport_pos + Vector2(screen_half_width, screen_half_height)
	global_position = global_position.clamp(top_left, bottom_right)

func handle_acceleration(input_axis, delta):
	if input_axis != Vector2.ZERO:
		velocity = velocity.move_toward(input_axis * movement_data.max_speed, movement_data.acceleration * delta)

func handle_air_resistance(input_axis, delta):
	if input_axis == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, movement_data.friction * delta)


# Upgrading


func add_weapon(weapon):
	if _check_weapon_duplicate(weapon): 
		var duplicate_weapon = _check_weapon_duplicate(weapon)
		upgrade_weapon(duplicate_weapon)
		weapon.queue_free()
	else:
		current_weapons.add_child(weapon)
		weapons.append(weapon)


func _check_weapon_duplicate(weapon):
	for i in current_weapons.get_children():
		if i.weapon_name == weapon.weapon_name: 
			return i
	
	return false

func upgrade_weapon(weapon: Weapon):
	weapon.upgrade()

# Invulnerability


func give_invulnerability():
	if health_system.is_invulnerable:
		$CollisionShape2D.set_deferred("disabled", true)
		%ShipSprite.material.set("shader_parameter/enabled", false)
		await get_tree().create_timer(0.05).timeout
		%ShipSprite.material.set("shader_parameter/enabled", true)
		animation_player.play("invulnerable_flash_anim")
	elif not health_system.is_invulnerable:
		$CollisionShape2D.set_deferred("disabled", false)


# Signals


func _on_hit_box_body_entered(_body):			
	health_system.handle_damage(10)


func _on_health_system_health_updated(health):
	player_health_updated.emit(health)


func _on_health_system_max_health_updated(max_health):
	player_max_health_updated.emit(max_health)


func _on_health_system_killed():
	emit_signal("player_killed")


func _on_xp_manager_leveled_up(required_xp, level):
	current_xp_required = required_xp
	current_level = level
	hud.update_max_xp(current_xp_required)


func _on_xp_manager_xp_updated(xp):
	current_xp = xp
	hud.update_xp_bar(current_xp)


func _on_upgrade_collector_area_entered(area):
	var upgrade_type: Weapon = area.upgrade_collected()
	add_weapon(upgrade_type)
