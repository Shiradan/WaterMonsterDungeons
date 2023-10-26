extends PopupPanel

signal confirm_delete


func _on_confirm_pressed():
	emit_signal("confirm_delete")
	$".".queue_free()


func _on_cancel_pressed():
	$".".queue_free()
