extends ParallaxBackground

@export var scrolling_speed = 50.0
@export var scroll_speed_increase = 30.0
@export var dark_layer_on = true

@onready var sprite_2d = $"ParallaxLayer+6/Sprite2D"

func _ready():
	EventManager.connect("difficulty_level_changed", increase_scroll_speed)
	sprite_2d.visible = dark_layer_on

func _process(delta):
	scroll_base_offset.y += scrolling_speed * delta


func increase_scroll_speed(_level):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scrolling_speed", scrolling_speed + scroll_speed_increase, 15)
