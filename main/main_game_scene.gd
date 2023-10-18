extends Node2D

@onready var character_name = $GameUI/CharacterName
@onready var general_info = $GameUI/GeneralInfo

func _ready():
	character_name.text=ClientManager.character.character_name
	general_info.text=str(ClientManager.character.level)+"级"+" "+\
		ClientManager.translate_race(ClientManager.character.race)+" "+\
		ClientManager.translate_job(ClientManager.character.job)
	if ClientManager.tab==0:
		setup_team_members()
	else:
		var tabContainer=$GameUI/TabContainer
		tabContainer.current_tab=ClientManager.tab
		_on_tab_container_tab_clicked(ClientManager.tab)
	
		
func setup_team_members():
	reset_member_list()
	var member_list=await ServerConnection.list_group_members()
	for member in member_list.group_users:
		var user_id=member.user.id
		var user_charactersStorageObjectList=await ServerConnection.read_user_characters_async(user_id)
		for object in user_charactersStorageObjectList:
			if int(object.active)==1:
				var member_active_character:Character=ClientManager.to_character(object)
				var members = $"GameUI/TabContainer/队伍/MarginContainer/Members"
				var memberRow:HBoxContainer=load("res://main/main_game_scene_pages/team_member_row.tscn").instantiate()
				memberRow.cname=member_active_character.character_name
				memberRow.level=member_active_character.level
				memberRow.race=member_active_character.race
				memberRow.job=member_active_character.job
				memberRow.hp=member_active_character.max_hp
				memberRow.mana=member_active_character.max_mana
				memberRow.bab=member_active_character.base_attack_bonus
				memberRow.ac=member_active_character.armor_class
				members.add_child(memberRow)

func reset_member_list():
	var members = $"GameUI/TabContainer/队伍/MarginContainer/Members"
	for member in members.get_children():
		member.queue_free()

func setup_character_list():
	var characterSlots=$"GameUI/TabContainer/你的角色/CharacterSlotContainer"
	var selections=$"GameUI/TabContainer/你的角色/SelectionContainer"
	#获取服务器端存储的角色清单
	var characters=[]
	var characterStorageObjectList=await ServerConnection.read_characters_async()
	for object in characterStorageObjectList:
		characters.append(ClientManager.to_character(object))
	ClientManager.characters=characters
	#获取当前账号各角色学习的技能清单
	ClientManager.skills=await ServerConnection.read_skills_learned_async()
	var i=0
	for c in ClientManager.characters:
		var characterSlot=characterSlots.get_child(i)
		characterSlot.text=c.character_name+": "+str(c.level)+"级"+ClientManager.translate_race(c.race)+ClientManager.translate_job(c.job)
		characterSlot.icon=null
		var selection:TextureRect=selections.get_child(i)
		if c.active==1:
			selection.modulate=Color.WHITE
		i+=1

func setup_attributes_stats():
	var strValue=$"GameUI/TabContainer/属性/AttributesValueContainer/StrContainer/StrValue"
	var dexValue=$"GameUI/TabContainer/属性/AttributesValueContainer/DexContainer/DexValue"
	var conValue=$"GameUI/TabContainer/属性/AttributesValueContainer/ConContainer/ConValue"
	var intValue=$"GameUI/TabContainer/属性/AttributesValueContainer/IntContainer/IntValue"
	var wisValue=$"GameUI/TabContainer/属性/AttributesValueContainer/WisContainer/WisValue"
	var chaValue=$"GameUI/TabContainer/属性/AttributesValueContainer/ChaContainer/ChaValue"
	
	strValue.text=str(ClientManager.character.attributes.str)
	dexValue.text=str(ClientManager.character.attributes.dex)
	conValue.text=str(ClientManager.character.attributes.con)
	intValue.text=str(ClientManager.character.attributes.int)
	wisValue.text=str(ClientManager.character.attributes.wis)
	chaValue.text=str(ClientManager.character.attributes.cha)
	
	var levelupPointsValue=$"GameUI/TabContainer/属性/LevelupPointsContainer/LevelupPointsValue"
	levelupPointsValue.text=str(ClientManager.character.levelup_attribute_points)
	var attributes_stats=$"GameUI/TabContainer/属性"
	attributes_stats.left_points=ClientManager.character.levelup_attribute_points
	
	setup_stats()
	
func setup_stats():
	var stats=$"GameUI/TabContainer/属性/Stats"
	stats.clear()
	stats.push_color(Color.BLUE)
	stats.append_text("[font_size=28px]基础数据[/font_size]\n")
	stats.push_font_size(24)
	stats.append_text(
		"[ul]生命值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.max_hp]
	)
	stats.append_text(
		"[ul]魔力值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.max_mana]
	)
	stats.append_text(
		"[ul]每回合魔力回复: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.mana_regeneration]
	)
	stats.append_text(
		"[ul]先攻加值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.initiative]
	)
	stats.append_text(
		"[ul]护甲等级(AC): [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.armor_class]
	)
	stats.append_text(
		"[ul]基础攻击加值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.base_attack_bonus]
	)
	stats.append_text(
		"[ul]回合前动作数: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.before_turn_actions]
	)
	stats.append_text(
		"[ul]回合中动作数: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.actions]
	)
	stats.append_text(
		"[ul]回合后动作数: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.character.after_turn_actions]
	)

func _on_tab_container_tab_clicked(tab):
	match tab:
		0:
			ClientManager.tab=tab
			setup_team_members()
		1:
			ClientManager.tab=tab
			setup_character_list()
		2:
			ClientManager.tab=tab
			setup_attributes_stats()
		3:
			ClientManager.tab=tab
		4:
			ClientManager.tab=tab
		5:
			ClientManager.tab=tab
		6:
			ClientManager.tab=tab
		7:
			ClientManager.tab=tab

func _on_character_slot_1_pressed():
	var characterSlot1=$"GameUI/TabContainer/你的角色/CharacterSlotContainer/CharacterSlot1"
	if characterSlot1.text=="" or characterSlot1.text==null:
		get_tree().change_scene_to_file("res://main/character_creation.tscn")
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
		var selection1=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection1"
		var selection2=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection2"
		var selection3=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection3"
		selection1.modulate=Color.WHITE
		selection2.modulate=Color.TRANSPARENT
		selection3.modulate=Color.TRANSPARENT
		character_name.text=ClientManager.character.character_name
		general_info.text=str(ClientManager.character.level)+"级"+" "+\
			ClientManager.translate_race(ClientManager.character.race)+" "+\
			ClientManager.translate_job(ClientManager.character.job)


func _on_character_slot_2_pressed():
	var characterSlot2=$"GameUI/TabContainer/你的角色/CharacterSlotContainer/CharacterSlot2"
	if characterSlot2.text=="" or characterSlot2.text==null:
		get_tree().change_scene_to_file("res://main/character_creation.tscn")
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
		var selection1=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection1"
		var selection2=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection2"
		var selection3=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection3"
		selection2.modulate=Color.WHITE
		selection1.modulate=Color.TRANSPARENT
		selection3.modulate=Color.TRANSPARENT
		character_name.text=ClientManager.character.character_name
		general_info.text=str(ClientManager.character.level)+"级"+" "+\
			ClientManager.translate_race(ClientManager.character.race)+" "+\
			ClientManager.translate_job(ClientManager.character.job)


func _on_character_slot_3_pressed():
	var characterSlot3=$"GameUI/TabContainer/你的角色/CharacterSlotContainer/CharacterSlot3"
	if characterSlot3.text=="" or characterSlot3.text==null:
		get_tree().change_scene_to_file("res://main/character_creation.tscn")
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
		var selection1=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection1"
		var selection2=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection2"
		var selection3=$"GameUI/TabContainer/你的角色/SelectionContainer/Selection3"
		selection3.modulate=Color.WHITE
		selection2.modulate=Color.TRANSPARENT
		selection1.modulate=Color.TRANSPARENT
		character_name.text=ClientManager.character.character_name
		general_info.text=str(ClientManager.character.level)+"级"+" "+\
			ClientManager.translate_race(ClientManager.character.race)+" "+\
			ClientManager.translate_job(ClientManager.character.job)


func _on_save_pressed():
	var levelupPointsValue=$"GameUI/TabContainer/属性/LevelupPointsContainer/LevelupPointsValue"
	if int(levelupPointsValue.text)<ClientManager.character.levelup_attribute_points:
		ClientManager.character.levelup_attribute_points=int(levelupPointsValue.text)
		var strValue=$"GameUI/TabContainer/属性/AttributesValueContainer/StrContainer/StrValue"
		var dexValue=$"GameUI/TabContainer/属性/AttributesValueContainer/DexContainer/DexValue"
		var conValue=$"GameUI/TabContainer/属性/AttributesValueContainer/ConContainer/ConValue"
		var intValue=$"GameUI/TabContainer/属性/AttributesValueContainer/IntContainer/IntValue"
		var wisValue=$"GameUI/TabContainer/属性/AttributesValueContainer/WisContainer/WisValue"
		var chaValue=$"GameUI/TabContainer/属性/AttributesValueContainer/ChaContainer/ChaValue"
		var saveAttributes={
			"str":int(strValue.text),
			"dex":int(dexValue.text),
			"con":int(conValue.text),
			"int":int(intValue.text),
			"wis":int(wisValue.text),
			"cha":int(chaValue.text)
		}
		ClientManager.character.attributes=saveAttributes
		ClientManager.update_active_character_by_attributes()
		var characterStorageObjectList:Array=[]
		for c in ClientManager.characters:
			if c.active==1:
				c=ClientManager.character
			characterStorageObjectList.append(ClientManager.to_character_storage_object(c))
		await ServerConnection.write_characters_async(characterStorageObjectList)
		setup_attributes_stats()
				
	