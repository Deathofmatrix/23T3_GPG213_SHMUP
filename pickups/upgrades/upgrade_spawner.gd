extends Node2D

@export var current_pickup_speed = 30
@export var all_weapon_upgrades: Array = [
	preload("res://weapons/pistol/pistol.tscn"),
	preload("res://weapons/shotgun/shotgun.tscn"),
	preload("res://weapons/wingsword/wing_sword.tscn"),
	preload("res://weapons/wingarang/wingarang_gun.tscn")
]

@onready var UpgradePickup = preload("res://pickups/upgrades/upgrade_pickup.tscn")
@onready var spawn_locations = $SpawnLocations

func _ready():
	EventManager.connect("player_leveled_up", spawn_upgrades)
	for i in all_weapon_upgrades:
		print(i)


func spawn_upgrades():
	var markers = spawn_locations.get_children()
	var upgrade1 = create_upgrade(markers[0])
	var upgrade2 = create_upgrade(markers[1])
	var upgrade3 = create_upgrade(markers[2])
	var current_onscreen_upgrades = [upgrade1, upgrade2, upgrade3]
	
	for upgrade in current_onscreen_upgrades:
		upgrade.upgrades_on_screen = current_onscreen_upgrades


func create_upgrade(marker):
	var selected_position = marker.position
	var upgrade_pickup = UpgradePickup.instantiate()
	upgrade_pickup.position = selected_position
	upgrade_pickup.movement_speed = current_pickup_speed
	upgrade_pickup.upgrade_type = assign_upgrade_type()
	upgrade_pickup.icon = upgrade_pickup.upgrade_type.icon_image
	add_child(upgrade_pickup)
	return upgrade_pickup


func assign_upgrade_type():
#	print("choosing upgrade")
	var upgrade_choice = all_weapon_upgrades[randi() % all_weapon_upgrades.size()].instantiate()
#	print(upgrade_choice)
	return upgrade_choice
