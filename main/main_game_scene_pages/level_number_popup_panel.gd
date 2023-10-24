extends PopupPanel
var text:String="":set=set_text
signal level_entered

func set_text(value):
	text=value
	emit_signal("level_entered")

func _on_level_number_text_submitted(new_text):
	if ClientManager.checkNumber(new_text):
		if int(new_text)>0:
			text=new_text

func _on_confirm_pressed():
	var new_text=$VBoxContainer/LevelNumber.text
	if ClientManager.checkNumber(new_text):
		if int(new_text)>0:
			text=new_text
