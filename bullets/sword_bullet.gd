extends Bullet

@export var bullet_lifetime: float = 2
@export var bullet_size = 1

@onready var lifespan_timer = $LifespanTimer
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	lifespan_timer.wait_time = bullet_lifetime
	sprite_2d.scale = Vector2(bullet_size, bullet_size)
	collision_shape_2d.scale = Vector2(bullet_size, bullet_size)

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	queue_free()
	var child_node = body.get_node_or_null("HealthSystem") 
	

	if child_node != null and child_node.has_method("handle_damage"):
		child_node.handle_damage(bullet_damage)


func _on_area_entered(area):
	if area.has_method("bullet_blocked"):
		area.bullet_blocked()
