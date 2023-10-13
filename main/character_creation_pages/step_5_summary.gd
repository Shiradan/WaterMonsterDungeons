extends Control

@onready var basicInfo=$HBoxContainer/BasicInfoPanel/BasicInfo
@onready var stats=$HBoxContainer/StatsPanel/Stats
@onready var skills=$HBoxContainer/SkillsPanel/Skills

func setup_creation_summary(character:Character,race:Race,job:Job,skills:Array,bonus_attribute_choice:int):
	character.level=1
	#计算最终属性值
	if !race.bonus_attributes.is_empty():
		character.attributes={
			"str":character.attributes.str+race.bonus_attributes.str,
			"dex":character.attributes.dex+race.bonus_attributes.dex,
			"con":character.attributes.con+race.bonus_attributes.con,
			"int":character.attributes.int+race.bonus_attributes.int,
			"wis":character.attributes.wis+race.bonus_attributes.wis,
			"cha":character.attributes.cha+race.bonus_attributes.cha
		}
	else:
		match bonus_attribute_choice:
			1:
				character.attributes={
					"str":character.attributes.str+race.bonus_attribute_points,
					"dex":character.attributes.dex,
					"con":character.attributes.con,
					"int":character.attributes.int,
					"wis":character.attributes.wis,
					"cha":character.attributes.cha
				}
			2:
				character.attributes={
					"str":character.attributes.str,
					"dex":character.attributes.dex+race.bonus_attribute_points,
					"con":character.attributes.con,
					"int":character.attributes.int,
					"wis":character.attributes.wis,
					"cha":character.attributes.cha
				}
			3:
				character.attributes={
					"str":character.attributes.str,
					"dex":character.attributes.dex,
					"con":character.attributes.con+race.bonus_attribute_points,
					"int":character.attributes.int,
					"wis":character.attributes.wis,
					"cha":character.attributes.cha
				}
			4:
				character.attributes={
					"str":character.attributes.str,
					"dex":character.attributes.dex,
					"con":character.attributes.con,
					"int":character.attributes.int+race.bonus_attribute_points,
					"wis":character.attributes.wis,
					"cha":character.attributes.cha
				}
			5:
				character.attributes={
					"str":character.attributes.str,
					"dex":character.attributes.dex,
					"con":character.attributes.con,
					"int":character.attributes.int,
					"wis":character.attributes.wis+race.bonus_attribute_points,
					"cha":character.attributes.cha
				}
			6:
				character.attributes={
					"str":character.attributes.str,
					"dex":character.attributes.dex,
					"con":character.attributes.con,
					"int":character.attributes.int,
					"wis":character.attributes.wis,
					"cha":character.attributes.cha+race.bonus_attribute_points
				}
	#计算一级max_hp=(体质-10)/2+职业HD
	character.max_hp=ClientManager.get_attr_mod(character.attributes.con)+job.hit_dice
	character.hp=character.max_hp
	#计算一级max_mana=职业一级mana+(智力-10)/2
	character.max_mana=job.l1_mana+ClientManager.get_attr_mod(character.attributes.int)
	character.mana=character.max_mana
	#计算先攻加值=(敏捷-10)/2+种族额外加值+可能有精通先攻（2）
	character.initiative=ClientManager.get_attr_mod(character.attributes.dex)+race.bonus_initiative
	for skill in skills:
		if skill.Skill_Index=="MISC-0":
			character.initiative+=2
	#计算AC=10+(敏捷-10)/2+种族额外加值
	character.armor_class=10+ClientManager.get_attr_mod(character.attributes.dex)+race.bonus_ac
	#计算bab=职业一级BAB+种族bab加值
	character.base_attack_bonus=job.l1_bab+race.bonus_ab
	
	character.before_turn_actions=ClientManager.get_bt_actions(character.level)
	character.after_turn_actions=ClientManager.get_at_actions(character.level)
	character.actions=ClientManager.get_actions(character.base_attack_bonus)
	
	setup_basic_info(character)
	setup_stats(character)
	setup_skills(skills)

func setup_basic_info(character:Character):
	pass

func setup_stats(character:Character):
	pass

func setup_skills(skills):
	pass
