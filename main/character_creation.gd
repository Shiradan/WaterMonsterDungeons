extends Node2D

var creation:Character=null

@onready var characterListPage=$CharacterList
@onready var step1=$Step1_ModeSelection
@onready var step2_buyAttributes=$Step2_BuyAttributes
@onready var step2_rollAttributes=$Step2_RollAttributes

func _ready():
	characterListPage.show()
	step1.hide()
	step2_buyAttributes.hide()
	step2_rollAttributes.hide()
	setup_character_list()
	
func setup_character_list():
	var characterSlots=$CharacterList/Panel/CharacterSlotContainer
	var selections=$CharacterList/Panel/SelectionContainer
	
	var i=0
	if ClientManager.characters.size()>0:
		for c in ClientManager.characters:
			var characterSlot=characterSlots.get_child(i)
			characterSlot.text=c.character_name
			characterSlot.icon=null
			if c.active==1:
				var selection=selections.get_child(i)
				selection.show()
			i+=1

func goto_step1():
	characterListPage.hide()
	step1.show()

func _on_character_slot_1_pressed():
	var characterSlot1=$CharacterList/Panel/CharacterSlotContainer/CharacterSlot1
	if characterSlot1.text=="" or characterSlot1.text==null:
		goto_step1()
	else:
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection1.show()
		selection2.hide()
		selection3.hide()


func _on_character_slot_2_pressed():
	var characterSlot2=$CharacterList/Panel/CharacterSlotContainer/CharacterSlot2
	if characterSlot2.text=="" or characterSlot2.text==null:
		goto_step1()
	else:
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection2.show()
		selection1.hide()
		selection3.hide()


func _on_character_slot_3_pressed():
	var characterSlot3=$CharacterList/Panel/CharacterSlotContainer/CharacterSlot3
	if characterSlot3.text=="" or characterSlot3.text==null:
		goto_step1()
	else:
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection3.show()
		selection2.hide()
		selection1.hide()


func _on_buy_points_pressed():
	var creation_name=$Step1_ModeSelection/Panel/CharacterNameContainer/CharacterName
	var creation_gender=$Step1_ModeSelection/Panel/GenderContainer/Gender
	creation=Character.new()
	creation.character_name=creation_name.text
	creation.gender=creation_gender.selected
	step1.hide()
	step2_buyAttributes.show()


func _on_roll_attributes_pressed():
	var creation_name=$Step1_ModeSelection/Panel/CharacterNameContainer/CharacterName
	var creation_gender=$Step1_ModeSelection/Panel/GenderContainer/Gender
	creation=Character.new()
	creation.character_name=creation_name.text
	creation.gender=creation_gender.selected
	step1.hide()
	step2_rollAttributes.show()
