extends HBoxContainer

var skill_name:String="":set=set_skill_name

func set_skill_name(value):
	skill_name=value
	$Label.text=value

func _on_button_pressed():
	$".".queue_free()
