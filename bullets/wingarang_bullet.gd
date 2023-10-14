extends Bullet

var rotation_speed = 10

func _ready():
	direction = Vector2.ZERO

func _process(delta):
	$".".rotate(1 * rotation_speed * delta)

func _on_body_entered(body):
	var child_node = body.get_node_or_null("HealthSystem") 

	if child_node != null and child_node.has_method("handle_damage"):
		child_node.handle_damage(bullet_damage)
