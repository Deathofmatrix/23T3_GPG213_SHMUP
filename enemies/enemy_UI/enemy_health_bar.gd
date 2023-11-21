class_name EnemyHealthBar
extends Control


@export var _current_max_health = 50
@export var _current_health = 50

@onready var health_bar = $VBoxContainer/HealthBar

func update_health_bar():
	health_bar.max_value = _current_max_health
	health_bar.value = _current_health
	


func _on_health_system_health_updated(health, _was_damaged):
	_current_health = health
	update_health_bar()
