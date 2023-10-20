extends Control

@onready var basicInfo=$HBoxContainer/BasicInfoPanel/BasicInfo
@onready var stats=$HBoxContainer/StatsPanel/Stats
@onready var skillsText=$HBoxContainer/SkillsPanel/Skills
var temp_character:Character

func reset():
	basicInfo.clear()
	stats.clear()
	skillsText.clear()
	temp_character=null

func setup_creation_summary(c:Character,race:Race,job:Job,skills:Array,bonus_attribute_choice:int):
	temp_character=Character.new()
	temp_character.character_name=c.character_name
	temp_character.gender=c.gender
	temp_character.attributes=c.attributes
	temp_character.job=c.job
	temp_character.race=c.race
	temp_character.skill_points=c.skill_points
	basicInfo.clear()
	stats.clear()
	skillsText.clear()
	temp_character.level=1
	#计算最终属性值
	if !race.bonus_attributes.is_empty():
		temp_character.attributes={
			"str":temp_character.attributes.str+race.bonus_attributes.str,
			"dex":temp_character.attributes.dex+race.bonus_attributes.dex,
			"con":temp_character.attributes.con+race.bonus_attributes.con,
			"int":temp_character.attributes.int+race.bonus_attributes.int,
			"wis":temp_character.attributes.wis+race.bonus_attributes.wis,
			"cha":temp_character.attributes.cha+race.bonus_attributes.cha
		}
	else:
		match bonus_attribute_choice:
			1:
				temp_character.attributes={
					"str":temp_character.attributes.str+race.bonus_attribute_points,
					"dex":temp_character.attributes.dex,
					"con":temp_character.attributes.con,
					"int":temp_character.attributes.int,
					"wis":temp_character.attributes.wis,
					"cha":temp_character.attributes.cha
				}
			2:
				temp_character.attributes={
					"str":temp_character.attributes.str,
					"dex":temp_character.attributes.dex+race.bonus_attribute_points,
					"con":temp_character.attributes.con,
					"int":temp_character.attributes.int,
					"wis":temp_character.attributes.wis,
					"cha":temp_character.attributes.cha
				}
			3:
				temp_character.attributes={
					"str":temp_character.attributes.str,
					"dex":temp_character.attributes.dex,
					"con":temp_character.attributes.con+race.bonus_attribute_points,
					"int":temp_character.attributes.int,
					"wis":temp_character.attributes.wis,
					"cha":temp_character.attributes.cha
				}
			4:
				temp_character.attributes={
					"str":temp_character.attributes.str,
					"dex":temp_character.attributes.dex,
					"con":temp_character.attributes.con,
					"int":temp_character.attributes.int+race.bonus_attribute_points,
					"wis":temp_character.attributes.wis,
					"cha":temp_character.attributes.cha
				}
			5:
				temp_character.attributes={
					"str":temp_character.attributes.str,
					"dex":temp_character.attributes.dex,
					"con":temp_character.attributes.con,
					"int":temp_character.attributes.int,
					"wis":temp_character.attributes.wis+race.bonus_attribute_points,
					"cha":temp_character.attributes.cha
				}
			6:
				temp_character.attributes={
					"str":temp_character.attributes.str,
					"dex":temp_character.attributes.dex,
					"con":temp_character.attributes.con,
					"int":temp_character.attributes.int,
					"wis":temp_character.attributes.wis,
					"cha":temp_character.attributes.cha+race.bonus_attribute_points
				}
	#计算一级max_hp=(体质-10)/2+职业HD
	temp_character.max_hp=ClientManager.get_attr_mod(temp_character.attributes.con)+job.hit_dice
	temp_character.hp=temp_character.max_hp
	#计算一级max_mana=职业一级mana+(智力-10)/2
	temp_character.max_mana=job.l1_mana+ClientManager.get_attr_mod(temp_character.attributes.int)
	temp_character.mana=temp_character.max_mana
	#计算先攻加值=(敏捷-10)/2+种族额外加值+可能有精通先攻（2）
	temp_character.initiative=ClientManager.get_attr_mod(temp_character.attributes.dex)+race.bonus_initiative
	for skill in skills:
		if skill.Skill_Index=="MISC-0":
			temp_character.initiative+=2
	#计算AC=10+(敏捷-10)/2+种族额外加值
	temp_character.armor_class=10+ClientManager.get_attr_mod(temp_character.attributes.dex)+race.bonus_ac
	#计算bab=职业一级BAB+种族bab加值
	temp_character.base_attack_bonus=job.l1_bab+race.bonus_ab
	if job.job_index==ClientManager.jobs.FIGHTER:
		for skill in skills:
			if skill.Skill_Index=="FIGHTER-2":
				temp_character.base_attack_bonus+=2
	temp_character.before_turn_actions=ClientManager.get_bt_actions(temp_character.level)
	temp_character.after_turn_actions=ClientManager.get_at_actions(temp_character.level)
	temp_character.actions=ClientManager.get_actions(temp_character.base_attack_bonus)
	
	setup_basic_info(temp_character,race,job)
	setup_stats(temp_character)
	setup_skills(skills,temp_character)

func setup_basic_info(character:Character,race:Race,job:Job):
	basicInfo.push_color(Color.BLUE)
	basicInfo.append_text("[font_size=28px]基本信息[/font_size]\n")
	basicInfo.push_font_size(24)
	basicInfo.append_text(
		"[ul]角色名: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.character_name]
	)
	basicInfo.append_text(
		"[ul]种族: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),race.cn_name]
	)
	basicInfo.append_text(
		"[ul]性别: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),ClientManager.get_gender_text(character.gender)]
	)
	basicInfo.append_text(
		"[ul]职业: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),job.cn_name]
	)
	basicInfo.append_text(
		"[ul]等级: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.level]
	)
	basicInfo.append_text("\n[font_size=28px]属性[/font_size]\n")
	basicInfo.append_text("[ul][color=#%s]力量: [/color][color=#%s]%s[/color][/ul]\n" % 
	[ClientManager.get_color_from_index(1).to_html(false),
	Color.WHITE.to_html(false),character.attributes.str])
	basicInfo.append_text("[ul][color=#%s]敏捷: [/color][color=#%s]%s[/color][/ul]\n" % 
	[ClientManager.get_color_from_index(2).to_html(false),
	Color.WHITE.to_html(false),character.attributes.dex])
	basicInfo.append_text("[ul][color=#%s]体质: [/color][color=#%s]%s[/color][/ul]\n" % 
	[ClientManager.get_color_from_index(3).to_html(false),
	Color.WHITE.to_html(false),character.attributes.con])
	basicInfo.append_text("[ul][color=#%s]智力: [/color][color=#%s]%s[/color][/ul]\n" % 
	[ClientManager.get_color_from_index(4).to_html(false),
	Color.WHITE.to_html(false),character.attributes.int])
	basicInfo.append_text("[ul][color=#%s]感知: [/color][color=#%s]%s[/color][/ul]\n" % 
	[ClientManager.get_color_from_index(5).to_html(false),
	Color.WHITE.to_html(false),character.attributes.wis])
	basicInfo.append_text("[ul][color=#%s]魅力: [/color][color=#%s]%s[/color][/ul]\n" % 
	[ClientManager.get_color_from_index(6).to_html(false),
	Color.WHITE.to_html(false),character.attributes.cha])
	

func setup_stats(character:Character):
	stats.push_color(Color.BLUE)
	stats.append_text("[font_size=28px]基础数据[/font_size]\n")
	stats.push_font_size(24)
	stats.append_text(
		"[ul]生命值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.max_hp]
	)
	stats.append_text(
		"[ul]魔力值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.max_mana]
	)
	stats.append_text(
		"[ul]每回合魔力回复: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.mana_regeneration]
	)
	stats.append_text(
		"[ul]先攻加值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.initiative]
	)
	stats.append_text(
		"[ul]护甲等级(AC): [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.armor_class]
	)
	stats.append_text(
		"[ul]基础攻击加值: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.base_attack_bonus]
	)
	stats.append_text(
		"[ul]回合前动作数: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.before_turn_actions]
	)
	stats.append_text(
		"[ul]回合中动作数: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.actions]
	)
	stats.append_text(
		"[ul]回合后动作数: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.after_turn_actions]
	)

func setup_skills(skills:Array,character:Character):
	skillsText.push_color(Color.BLUE)
	skillsText.append_text("[font_size=28px]技能相关[/font_size]\n")
	skillsText.push_font_size(24)
	skillsText.append_text(
		"[ul]剩余技能点: [color=#%s]%s[/color][/ul]\n" % [Color.WHITE.to_html(false),character.skill_points]
	)
	
	skillsText.append_text("[ul]已学技能: [/ul]\n")
	for skill in skills:
		skillsText.append_text(
			"\t\t- [color=#%s]%s[/color]\n" % 
			[Color.SALMON.to_html(false),skill.cn_name]
		)


	
