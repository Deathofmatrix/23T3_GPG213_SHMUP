extends Node2D

@export var player: Player
@export var current_pickup_speed = 30
@export var all_weapon_upgrades: Array = [
	preload("res://weapons/pistol/pistol.tscn"),
	preload("res://weapons/shotgun/shotgun.tscn"),
	preload("res://weapons/wingsword/wing_sword.tscn"),
	preload("res://weapons/wingarang/wingarang_gun.tscn")
]

var default_heal_upgrade = preload("res://weapons/default_health_upgrade.tscn")

@onready var UpgradePickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")
@onready var spawn_locations = $SpawnLocations

func _ready():
	EventManager.connect("player_leveled_up", spawn_upgrades)
	for i in all_weapon_upgrades:
		print(i)


func spawn_upgrades():
	var markers = spawn_locations.get_children()
	var current_onscreen_upgrades: Array = []
	var upgrade1 = create_upgrade(markers[0], current_onscreen_upgrades)
	current_onscreen_upgrades.append(upgrade1)
	var upgrade2 = create_upgrade(markers[1], current_onscreen_upgrades)
	current_onscreen_upgrades.append(upgrade2)
	var upgrade3 = create_upgrade(markers[2], current_onscreen_upgrades)
	current_onscreen_upgrades.append(upgrade3)
	
	for upgrade in current_onscreen_upgrades:
		upgrade.upgrades_on_screen = current_onscreen_upgrades


func create_upgrade(marker, current_onscreen_upgrades: Array):
	var selected_position = marker.position
	var upgrade_pickup = UpgradePickup.instantiate()
	upgrade_pickup.position = selected_position
	upgrade_pickup.movement_speed = current_pickup_speed
	upgrade_pickup.upgrade_type = assign_upgrade_type(current_onscreen_upgrades)
	upgrade_pickup.icon = upgrade_pickup.upgrade_type.icon_image
	add_child(upgrade_pickup)
	return upgrade_pickup


func assign_upgrade_type(current_onscreen_upgrades: Array):
	var possible_upgrades_array: Array = all_weapon_upgrades
	if player.weapons.size() >= 2:
		possible_upgrades_array.clear()
		for i in player.weapons:
			possible_upgrades_array.append(load(i.scene_file_path))
	
	var not_maxxed_upgrade_array: Array = []
	for possible_upgrade in possible_upgrades_array:
		var possible_upgrade_instance = possible_upgrade.instantiate() as Weapon
		_check_if_upgrade_maxxed(not_maxxed_upgrade_array, possible_upgrade_instance)
		possible_upgrade_instance.queue_free()
	
	var no_duplicate_onscreen_array: Array = []
	if not current_onscreen_upgrades.is_empty():
		for not_maxxed_upgrade in not_maxxed_upgrade_array:
			var not_maxxed_upgrade_instance = not_maxxed_upgrade.instantiate() as Weapon
			_check_if_upgrades_onscreen_match(no_duplicate_onscreen_array, current_onscreen_upgrades, not_maxxed_upgrade_instance)
			not_maxxed_upgrade_instance.queue_free()
	else:
		no_duplicate_onscreen_array = not_maxxed_upgrade_array
	
	if no_duplicate_onscreen_array.size() < 3:
		for missing_upgrade in (3 - no_duplicate_onscreen_array.size()):
			no_duplicate_onscreen_array.append(default_heal_upgrade)
	
	var upgrade_choice = no_duplicate_onscreen_array.pick_random().instantiate() as Weapon
	print(upgrade_choice.scene_file_path)
	return upgrade_choice


func _check_if_upgrade_maxxed(not_maxxed_upgrade_array: Array, possible_upgrade_instance):
	for equiped_upgrade in player.weapons:
		if possible_upgrade_instance.weapon_name == equiped_upgrade.weapon_name:
			if not equiped_upgrade.check_if_can_upgrade(): 
				return
			not_maxxed_upgrade_array.append(load(possible_upgrade_instance.scene_file_path))
			print ("appended" + possible_upgrade_instance.scene_file_path)
	not_maxxed_upgrade_array.append(load(possible_upgrade_instance.scene_file_path))
	print ("appended" + possible_upgrade_instance.scene_file_path)


func _check_if_upgrades_onscreen_match(no_duplicate_onscrren_arr: Array, current_onscreen_upgrades: Array, not_maxxed_upgrade_instance):
	for onscreen_upgrade in current_onscreen_upgrades:
		if not_maxxed_upgrade_instance.weapon_name == onscreen_upgrade.upgrade_type.weapon_name:
			return
	no_duplicate_onscrren_arr.append(load(not_maxxed_upgrade_instance.scene_file_path))
	print ("appended" + not_maxxed_upgrade_instance.scene_file_path)
