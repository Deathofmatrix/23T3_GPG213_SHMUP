extends PanelContainer

signal popup_finished()

@onready var upgrade_text = %UpgradeText
@onready var upgrade_description_text = %UpgradeDescriptionText
@onready var popup_animation_player = %PopupAnimationPlayer

var upgrade_queue: Array[UpgradeDataResource]
var is_looping_queue = false

func _ready():
	hide()


func _update_text(upgrade_data: UpgradeDataResource):
	upgrade_text.text = upgrade_data.upgrade_name + " " + str(upgrade_data.upgrade_level)
	upgrade_description_text.text = upgrade_data.upgrade_description


func show_upgrade_info(new_upgrade_data: UpgradeDataResource):
	_update_text(new_upgrade_data)
	show()
	popup_animation_player.play("popin_anim")
	await popup_animation_player.animation_finished
	await get_tree().create_timer(2).timeout
	popup_animation_player.play_backwards("popin_anim")
	await popup_animation_player.animation_finished
	emit_signal("popup_finished")


func loop_queued_upgrades():
	is_looping_queue = true
	var entry = upgrade_queue.pop_back()
	while entry != null:
		show_upgrade_info(entry)
		await self.popup_finished
		entry = upgrade_queue.pop_back()
	is_looping_queue = false


func _on_player_upgrade_added_or_upgraded(weapon):
	var new_upgrade_data: UpgradeDataResource = UpgradeDataResource.new()
	new_upgrade_data.upgrade_name = weapon.weapon_name
	new_upgrade_data.upgrade_level = weapon.upgrade_number
	new_upgrade_data.upgrade_description = weapon.current_description
	upgrade_queue.push_front(new_upgrade_data)
	if not is_looping_queue:
		loop_queued_upgrades()
