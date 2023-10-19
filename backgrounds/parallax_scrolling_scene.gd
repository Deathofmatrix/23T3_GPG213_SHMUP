extends ParallaxBackground

@export var scrolling_speed = 50
@export var increase = 50

func _ready():
	EventManager.connect("difficulty_level_changed", increase_paralax_speed)

func _process(delta):
	scroll_base_offset.y += scrolling_speed * delta


func increase_paralax_speed(_difficulty_level):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scrolling_speed", scrolling_speed + increase, 15)
