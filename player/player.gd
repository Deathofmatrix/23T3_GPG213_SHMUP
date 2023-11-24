class_name Player
extends CharacterBody2D

signal player_health_updated(health)
signal player_max_health_updated(max_health)
signal player_killed
signal upgrade_added_or_upgraded(weapon)

@export var health_system: HealthSystem
@export var hud: HUD
@export var movement_data: MovementData
@export var weapons: Array[Weapon]
@export var starting_max_health = 50

var current_level = 1
var current_xp = 1
var current_xp_required = 1

var viewport_pos: Vector2
var screen_half_height: int = 180
var screen_half_width: int = 224

var future_position: Vector2

var Pistol = preload("res://weapons/pistol/pistol.tscn")
var new_weapon_sound = preload("res://player/audio/new_weapon_sound.ogg")
var upgrade_weapon_sound = preload("res://player/audio/upgrade_weapon_sound.ogg")

@onready var animation_player = $AnimationPlayer
@onready var current_weapons = %CurrentWeapons
@onready var hurt_sound_player = $Audio/HurtSoundPlayer
@onready var upgrade_sound_player = $Audio/UpgradeSoundPlayer
@onready var movement_sound_player = $Audio/MovementSoundPlayer
@onready var future_position_marker = $FuturePosition


func _ready():
	GlobalPlayerInfo.player = self
	health_system.change_max_health(starting_max_health)
	add_weapon(Pistol.instantiate())
	viewport_pos = get_viewport_rect().position
	EventManager.connect("boss_spawned", change_viewport_size)


func _process(_delta):
	GlobalPlayerInfo.player_position = global_position
	lock_player_to_screen()
	give_invulnerability()
	movement_animation()
	movement_sound()
	move_future_position()
#	if Input.is_action_just_pressed("secondary_action"):
#		health_system.change_max_health(200)
#	if Input.is_action_just_pressed("primary_action"):
#		health_system.change_max_health(100)	

func _physics_process(delta):
	
	var input_axis = Input.get_vector("left", "right", "up", "down")
	handle_acceleration(input_axis, delta)
	handle_air_resistance(input_axis, delta)
	if input_axis.x != 0:
		%ShipSprite.scale.x = 0.9
	else:
		%ShipSprite.scale.x = 1
	move_and_slide()
	
	look_at(get_global_mouse_position())


# Movement
func change_viewport_size():
	viewport_pos += Vector2(0, 180)
	screen_half_height *= 2
	screen_half_width *= 2


func lock_player_to_screen():
	var top_left = viewport_pos - Vector2(screen_half_width, screen_half_height)
	var bottom_right = viewport_pos + Vector2(screen_half_width, screen_half_height)
	global_position = global_position.clamp(top_left + Vector2(10, 10), bottom_right - Vector2(10, 10))


func handle_acceleration(input_axis, delta):
	if input_axis != Vector2.ZERO:
		velocity = velocity.move_toward(input_axis * movement_data.max_speed, movement_data.acceleration * delta)


func handle_air_resistance(input_axis, delta):
	if input_axis == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, movement_data.friction * delta)


func movement_sound():
	var current_percentage = velocity.length() / movement_data.max_speed
	
	movement_sound_player.pitch_scale = lerpf(0.5, 1.5, current_percentage)


func movement_animation():
	if velocity.length() != 0:
		animation_player.queue("ship_flame_anim")
	if velocity.length() == 0:
		animation_player.play("RESET")


func move_future_position():
	future_position_marker.global_position = position + velocity / 3
	future_position = future_position_marker.global_position

# Upgrading


func add_weapon(weapon):
	if weapon.has_method("heal_player"):
		health_system.handle_heal(weapon.heal_player())
	elif _check_weapon_duplicate(weapon): 
		var duplicate_weapon = _check_weapon_duplicate(weapon)
		upgrade_weapon(duplicate_weapon)
		weapon.queue_free()
		emit_signal("upgrade_added_or_upgraded", duplicate_weapon)
		upgrade_sound_player.stream = upgrade_weapon_sound
		upgrade_sound_player.play()
		
	else:
		current_weapons.add_child(weapon)
		weapons.append(weapon)
		emit_signal("upgrade_added_or_upgraded", weapon)
		upgrade_sound_player.stream = new_weapon_sound
		upgrade_sound_player.play()


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


func _on_hit_box_body_entered(body):
	health_system.handle_damage(body.damage)
	


func _on_health_system_health_updated(health, was_damaged):
	player_health_updated.emit(health)
	if was_damaged:
		$Audio/HurtSoundPlayer.play()
	elif not was_damaged:
		$Audio/HealSoundPlayer.play()


func _on_health_system_max_health_updated(max_health):
	player_max_health_updated.emit(max_health)


func _on_health_system_killed():
	emit_signal("player_killed")
	AudioServer.set_bus_effect_enabled(0, 0, false)
	queue_free()


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


func _on_weapon_clear_box_area_entered(area):
	if area.has_method("clear_weapon"):
		area.clear_weapon()


func _on_health_system_reached_low_health(is_low_health):
	AudioServer.set_bus_effect_enabled(0, 0, is_low_health)
