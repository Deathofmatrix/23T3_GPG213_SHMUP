extends PanelContainer

signal animation_over()

@onready var upgrade_text = %UpgradeText
@onready var upgrade_description_text = %UpgradeDescriptionText
@onready var popup_animation_player = %PopupAnimationPlayer

var upgrade_queue: Array[Array] = []

var is_waiting_for_animation: bool = false

func _ready():
	hide()


func _update_text(upgrade_name: String, upgrade_level: int, upgrade_description: String):
	upgrade_text.text = upgrade_name + " " + str(upgrade_level)
	upgrade_description_text.text = upgrade_description

func show_upgrade_info(upgrade_name: String, upgrade_level: int, upgrade_description: String):
	
	
	# remove if stacking works
	if is_waiting_for_animation:
		await self.animation_over
	is_waiting_for_animation = true
	# end


	_update_text(upgrade_name, upgrade_level, upgrade_description)
	show()
	popup_animation_player.play("popin_anim")
	await popup_animation_player.animation_finished
	await get_tree().create_timer(3).timeout
	popup_animation_player.play_backwards("popin_anim")
	await popup_animation_player.animation_finished
	
	
	# remove if stacking works
	is_waiting_for_animation = false
	#end
	
	
	emit_signal("animation_over")




func _on_player_upgrade_added_or_upgraded(upgrade_name, upgrade_level, upgrade_description):
#	var new_upgrade_info: Array = [upgrade_name, upgrade_level, upgrade_description]
#
#	if len(upgrade_queue) > 0:
#		upgrade_queue.push_front(new_upgrade_info)
#
#	else:
#		upgrade_queue.append(new_upgrade_info)
#
#		var entry = upgrade_queue.pop_back()
#		while entry != null:
#			show_upgrade_info(entry[0], entry[1], entry[2])
#			await self.animation_over
#			entry = upgrade_queue.pop_back()


	show_upgrade_info(upgrade_name, upgrade_level, upgrade_description)
