extends Area2D

@export var upgrade_type: Weapon

var upgrades_on_screen: Array
var movement_speed = 30
var icon: Texture2D

@onready var icon_sprite = %IconSprite
@onready var cpu_particles_2d = $CPUParticles2D
@onready var icon_background = $IconBackground

func _ready():
	set_icon()

func _physics_process(delta):
	position += Vector2.DOWN * movement_speed * delta


func upgrade_collected():
	cpu_particles_2d.scale_amount_min = 4
	cpu_particles_2d.scale_amount_max = 6
	for upgrades in upgrades_on_screen:
		upgrades.destroy_pickup()
	return upgrade_type


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func destroy_pickup():
	icon_background.hide()
	cpu_particles_2d.restart()
	await get_tree().create_timer(cpu_particles_2d.lifetime).timeout
	queue_free()


func set_icon():
#	print(icon)
	icon_sprite.set_texture(icon)
