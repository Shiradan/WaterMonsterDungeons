extends Node2D

var creation:Character=Character.new()
var selected_skills:Array=[]
var race:Race=Race.new()
var job:Job=Job.new()
var bonus_attribute_choice:int=0
var mode:int=-1
var dice_rolled:bool=false

@onready var characterListPage=$CharacterList
@onready var step1=$Step1_ModeSelection
@onready var step2_buyAttributes=$Step2_BuyAttributes
@onready var step2_rollAttributes=$Step2_RollAttributes
@onready var step3_raceAndJob=$Step3_RaceAndJob
@onready var step4_skillSelection=$Step4_SkillSelection
@onready var step5_summary=$Step5_Summary

func _ready():
	characterListPage.show()
	step1.hide()
	step2_buyAttributes.hide()
	step2_rollAttributes.hide()
	step3_raceAndJob.hide()
	step4_skillSelection.hide()
	step5_summary.hide()
	setup_character_list()
	
func setup_character_list():
	var characterSlots=$CharacterList/Panel/CharacterSlotContainer
	var selections=$CharacterList/Panel/SelectionContainer
	#获取服务器端存储的角色清单
	var characters=[]#需要修改
	ClientManager.characters=characters
	#获取当前已激活角色学习的技能清单
	var skillsLearned=[]#需要修改
	ClientManager.learned_skills=skillsLearned
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
		ClientManager.character=ClientManager.characters[0]
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
		ClientManager.character=ClientManager.characters[1]
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
		ClientManager.character=ClientManager.characters[2]
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection3.show()
		selection2.hide()
		selection1.hide()


func _on_buy_points_pressed():
	var creation_name=$Step1_ModeSelection/Panel/CharacterNameContainer/CharacterName
	var creation_gender=$Step1_ModeSelection/Panel/GenderContainer/Gender
	creation_name.text.replace(" ","")
	if ClientManager.checkString(creation_name.text):
		if(creation_name.text!="" and creation_gender.selected!=-1):
			creation.character_name=creation_name.text
			creation.gender=creation_gender.selected
			step1.hide()
			mode=0
			step2_buyAttributes.show()


func _on_roll_attributes_pressed():
	var creation_name=$Step1_ModeSelection/Panel/CharacterNameContainer/CharacterName
	var creation_gender=$Step1_ModeSelection/Panel/GenderContainer/Gender
	creation_name.text.replace(" ","")
	if ClientManager.checkString(creation_name.text):
		if(creation_name.text!="" and creation_gender.selected!=-1):
			creation.character_name=creation_name.text
			creation.gender=creation_gender.selected
			step1.hide()
			mode=1
			step2_rollAttributes.show()


func _on_go_back_pressed():
	step1.hide()
	characterListPage.show()
	setup_character_list()


func _on_pre_step_buy_attributes_pressed():
	step2_buyAttributes.hide()
	step1.show()


func _on_pre_step_roll_attributes_pressed():
	step2_rollAttributes.hide()
	step1.show()


func _on_next_step_buy_attributes_pressed():
	var strValue=int(($Step2_BuyAttributes/Panel/AttributesValueContainer/StrContainer/StrValue).text)
	var dexValue=int(($Step2_BuyAttributes/Panel/AttributesValueContainer/DexContainer/DexValue).text)
	var conValue=int(($Step2_BuyAttributes/Panel/AttributesValueContainer/ConContainer/ConValue).text)
	var intValue=int(($Step2_BuyAttributes/Panel/AttributesValueContainer/IntContainer/IntValue).text)
	var wisValue=int(($Step2_BuyAttributes/Panel/AttributesValueContainer/WisContainer/WisValue).text)
	var chaValue=int(($Step2_BuyAttributes/Panel/AttributesValueContainer/ChaContainer/ChaValue).text)
	
	var bpValue=int(($Step2_BuyAttributes/Panel/BuyPointsContainer/Value).text)
	
	if bpValue==0:
		var creation_attributes={
			"str":strValue,
			"dex":dexValue,
			"con":conValue,
			"int":intValue,
			"wis":wisValue,
			"cha":chaValue
		}
		creation.attributes=creation_attributes
		step2_buyAttributes.hide()
		step3_raceAndJob.show()


func _on_next_step_roll_attributes_pressed():
	var strValue=int(($Step2_RollAttributes/Panel/AttributesValueContainer/StrContainer/StrValue).text)
	var dexValue=int(($Step2_RollAttributes/Panel/AttributesValueContainer/DexContainer/DexValue).text)
	var conValue=int(($Step2_RollAttributes/Panel/AttributesValueContainer/ConContainer/ConValue).text)
	var intValue=int(($Step2_RollAttributes/Panel/AttributesValueContainer/IntContainer/IntValue).text)
	var wisValue=int(($Step2_RollAttributes/Panel/AttributesValueContainer/WisContainer/WisValue).text)
	var chaValue=int(($Step2_RollAttributes/Panel/AttributesValueContainer/ChaContainer/ChaValue).text)
	
	if dice_rolled:
		var creation_attributes={
			"str":strValue,
			"dex":dexValue,
			"con":conValue,
			"int":intValue,
			"wis":wisValue,
			"cha":chaValue
		}
		creation.attributes=creation_attributes
		step2_rollAttributes.hide()
		step3_raceAndJob.show()


func _on_step_2_roll_attributes_rolled_dice():
	dice_rolled=true


func _on_pre_step_race_and_job_pressed():
	step3_raceAndJob.hide()
	match mode:
		0:
			step2_buyAttributes.show()
		1:
			step2_rollAttributes.show()


func _on_next_step_race_and_job_pressed():
	var raceOption=$Step3_RaceAndJob/Panel/RaceContainer/RaceOptionButton
	var jobOption=$Step3_RaceAndJob/Panel/JobContainer/JobOptionButton
	var bonusAttributeOption=$Step3_RaceAndJob/Panel/BonusAttributeContainer/BonuaAttributeOptionButton
	
	if raceOption.selected!=-1 and jobOption.selected!=-1:
		if raceOption.selected==ClientManager.races.HUMAN or raceOption.selected==ClientManager.races.HALF_ELF:
			if bonusAttributeOption.selected==-1:
				return
			else:
				bonus_attribute_choice=bonusAttributeOption.selected+1
		race=ClientManager.get_race_from_index(raceOption.selected)
		job=ClientManager.get_job_from_index(jobOption.selected)
		creation.job=job.job_index
		creation.race=race.race_index
		creation.skill_points=job.l1_skill_points+race.bonus_skill_points
		var skillList:TextDatabase=ClientManager.get_skill_list(job.job_index)
		step4_skillSelection.skillList=skillList
		step4_skillSelection.skillPoints=creation.skill_points
		step3_raceAndJob.hide()
		step4_skillSelection.show()
		step4_skillSelection.setup_skill_list()
		


func _on_pre_step_skill_selection_pressed():
	step4_skillSelection.hide()
	step3_raceAndJob.show()


func _on_next_step_skill_selection_pressed():
	creation.skill_points=step4_skillSelection.skillPoints
	selected_skills=step4_skillSelection.get_selected_skills()
	step5_summary.setup_creation_summary(creation,race,job,selected_skills,bonus_attribute_choice)
	step4_skillSelection.hide()
	step5_summary.show()


func _on_pre_step_summary_pressed():
	step5_summary.temp_character=null
	step5_summary.hide()
	step4_skillSelection.show()


func _on_next_step_summary_pressed():
	creation=step5_summary.temp_character

