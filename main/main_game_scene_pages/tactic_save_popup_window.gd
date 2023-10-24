extends PopupPanel

var text:String="":set=set_text
signal name_entered

func set_text(value):
	text=value
	emit_signal("name_entered")

func _on_line_edit_text_submitted(new_text):
	if ClientManager.checkString(new_text):
		text=new_text

func _on_button_pressed():
	var new_text=$VBoxContainer/LineEdit.text
	if ClientManager.checkString(new_text):
		text=new_text
