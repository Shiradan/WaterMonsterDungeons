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
	setup_character_list()
	characterListPage.show()
	step1.hide()
	step2_buyAttributes.hide()
	step2_rollAttributes.hide()
	step3_raceAndJob.hide()
	step4_skillSelection.hide()
	step5_summary.hide()
	
	
func setup_character_list():
	var characterSlots=$CharacterList/Panel/CharacterSlotContainer
	var selections=$CharacterList/Panel/SelectionContainer
	#获取服务器端存储的角色清单
	var characters=[]
	var characterStorageObjectList=await ServerConnection.read_characters_async()
	for object in characterStorageObjectList:
		characters.append(ClientManager.to_character(object))
	ClientManager.characters=characters#需要修改
	#获取当前账号各角色学习的技能清单
	ClientManager.skills=await ServerConnection.read_skills_learned_async()
	var i=0
	if ClientManager.characters.size()>0:
		for c in ClientManager.characters:
			var characterSlot=characterSlots.get_child(i)
			characterSlot.text=c.character_name+": "+str(c.level)+"级"+ClientManager.translate_race(c.race)+ClientManager.translate_job(c.job)
			characterSlot.icon=null
			var selection:TextureRect=selections.get_child(i)
			if c.active==1:
				selection.modulate=Color.WHITE
				ClientManager.character=c
				for skillsLearned in ClientManager.skills:
					if skillsLearned.character_name==c.character_name:
						ClientManager.learned_skills=skillsLearned.learned_skills
			i+=1


func goto_step1():
	characterListPage.hide()
	step1.show()

func _on_character_slot_1_pressed():
	var characterSlot1=$CharacterList/Panel/CharacterSlotContainer/CharacterSlot1
	if characterSlot1.text=="" or characterSlot1.text==null:
		goto_step1()
	else:
		var i=0
		var characterStorageObjectList:Array=[]
		while i<ClientManager.characters.size():
			if i==0:
				ClientManager.characters[i].active=1
				ClientManager.character=ClientManager.characters[i]
			else:
				ClientManager.characters[i].active=0
			characterStorageObjectList.append(ClientManager.to_character_storage_object(ClientManager.characters[i]))
			i+=1
		await ServerConnection.write_characters_async(characterStorageObjectList)
		for skillsLearned in ClientManager.skills:
			if skillsLearned.character_name==ClientManager.character.character_name:
				ClientManager.learned_skills=skillsLearned.learned_skills
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection1.modulate=Color.WHITE
		selection2.modulate=Color.TRANSPARENT
		selection3.modulate=Color.TRANSPARENT


func _on_character_slot_2_pressed():
	var characterSlot2=$CharacterList/Panel/CharacterSlotContainer/CharacterSlot2
	if characterSlot2.text=="" or characterSlot2.text==null:
		goto_step1()
	else:
		var i=0
		var characterStorageObjectList:Array=[]
		while i<ClientManager.characters.size():
			if i==1:
				ClientManager.characters[i].active=1
				ClientManager.character=ClientManager.characters[i]
			else:
				ClientManager.characters[i].active=0
			characterStorageObjectList.append(ClientManager.to_character_storage_object(ClientManager.characters[i]))
			i+=1
		await ServerConnection.write_characters_async(characterStorageObjectList)
		
		for skillsLearned in ClientManager.skills:
			if skillsLearned.character_name==ClientManager.character.character_name:
				ClientManager.learned_skills=skillsLearned.learned_skills
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection2.modulate=Color.WHITE
		selection1.modulate=Color.TRANSPARENT
		selection3.modulate=Color.TRANSPARENT


func _on_character_slot_3_pressed():
	var characterSlot3=$CharacterList/Panel/CharacterSlotContainer/CharacterSlot3
	if characterSlot3.text=="" or characterSlot3.text==null:
		goto_step1()
	else:
		var i=0
		var characterStorageObjectList:Array=[]
		while i<ClientManager.characters.size():
			if i==2:
				ClientManager.characters[i].active=1
				ClientManager.character=ClientManager.characters[i]
			else:
				ClientManager.characters[i].active=0
			characterStorageObjectList.append(ClientManager.to_character_storage_object(ClientManager.characters[i]))
			i+=1
		await ServerConnection.write_characters_async(characterStorageObjectList)
		for skillsLearned in ClientManager.skills:
			if skillsLearned.character_name==ClientManager.character.character_name:
				ClientManager.learned_skills=skillsLearned.learned_skills
		var selection1=$CharacterList/Panel/SelectionContainer/Selection1
		var selection2=$CharacterList/Panel/SelectionContainer/Selection2
		var selection3=$CharacterList/Panel/SelectionContainer/Selection3
		selection3.modulate=Color.WHITE
		selection2.modulate=Color.TRANSPARENT
		selection1.modulate=Color.TRANSPARENT


func _on_buy_points_pressed():
	var creation_name=$Step1_ModeSelection/Panel/CharacterNameContainer/CharacterName
	var creation_gender=$Step1_ModeSelection/Panel/GenderContainer/Gender
	creation_name.text.replace(" ","")
	if ClientManager.checkString(creation_name.text):
		if(creation_name.text!="" and creation_gender.selected!=-1):
			var is_available=await ServerConnection.check_name_availability(creation_name.text)
			if is_available:
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
			var is_available=await ServerConnection.check_name_availability(creation_name.text)
			if is_available:
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
	var is_available=await ServerConnection.register_name_storage(creation.character_name)
	if is_available:
		var charactersStrorageObjectList:Array=await ServerConnection.read_characters_async()
	#如果是初次创建角色，那么自动激活，否则不激活
		if charactersStrorageObjectList.size()==0:
			creation.active=1
		var characterStrorageObject=ClientManager.to_character_storage_object(creation)
		charactersStrorageObjectList.append(characterStrorageObject)
		await ServerConnection.write_characters_async(charactersStrorageObjectList)
		
		var skillsStorageObjectList:Array=await ServerConnection.read_skills_learned_async()
		if skillsStorageObjectList.size()==0:
			ClientManager.learned_skills=selected_skills
		var skillsStorageObject=ClientManager.to_skill_storage_object(creation.character_name,selected_skills)
		skillsStorageObjectList.append(skillsStorageObject)
		await ServerConnection.write_skills_learned_async(skillsStorageObjectList)
	
		step5_summary.hide()
		setup_character_list()
		characterListPage.show()
		step1.reset()
		step2_buyAttributes.reset()
		step2_rollAttributes.reset()
		step3_raceAndJob.reset()
		step4_skillSelection.reset()
		step5_summary.reset()
		reset_variables()
		
func reset_variables():
	creation=Character.new()
	selected_skills=[]
	race=Race.new()
	job=Job.new()
	bonus_attribute_choice=0
	mode=-1
	dice_rolled=false
		
func _on_enter_wmd_pressed():
	get_tree().change_scene_to_file("res://main/main_game_scene.tscn")
