extends HBoxContainer

var skill_name:String="":set=set_skill_name
var priority=-1:set=set_priority

func set_skill_name(value):
	skill_name=value
	$Label.text=value

func set_priority(value):
	priority=value
	$OptionButton.selected=value

func _on_button_pressed():
	$".".queue_free()


func _on_option_button_item_selected(index):
	priority=index
