extends Button

const icon_pressed := preload("res://assets/character_creation/buttons/chevron-right.svg")
const icon_released := preload("res://assets/character_creation/buttons/chevron-up.svg")

@warning_ignore("shadowed_variable_base_class")
func _on_toggled(button_pressed):
	icon = icon_pressed if button_pressed else icon_released
