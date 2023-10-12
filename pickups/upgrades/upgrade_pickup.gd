extends Area2D

@export var upgrade_type: Weapon

var upgrades_on_screen: Array
var movement_speed
var icon: Texture2D

@onready var icon_sprite = %IconSprite

func _ready():
	set_icon()

func _physics_process(delta):
	position += Vector2.DOWN * movement_speed * delta


func upgrade_collected():
	for upgrades in upgrades_on_screen:
		upgrades.queue_free()
	return upgrade_type


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func set_icon():
#	print(icon)
	icon_sprite.set_texture(icon)
