extends PanelContainer

@onready var upgrade_text = %UpgradeText
@onready var upgrade_description_text = %UpgradeDescriptionText

func update_text(upgrade_name: String, upgrade_level: int, upgrade_description: String):
	upgrade_text.text = upgrade_name + " " + str(upgrade_level)
	upgrade_description_text = upgrade_description


