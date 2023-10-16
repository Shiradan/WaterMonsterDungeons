extends Control

func reset():
	var cname=$Panel/CharacterNameContainer/CharacterName
	cname.text=""
	var gender=$Panel/GenderContainer/Gender
	gender.selected=-1
