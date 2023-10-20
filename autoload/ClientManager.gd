extends Node

enum races {
	HUMAN=0,
	DWARF=1,
	ELF=2,
	GNOME=3,
	HALF_ELF=4,
	HALFLING=5,
	HALF_ORC=6
}

enum jobs {
	FIGHTER=0,
	MAGE=1,
	CLERIC=2
}

var level_exp=[
	0,
	2000,
	5000,
	9000,
	15000,
	23000,
	35000,
	51000,
	75000,
	105000,
	155000,
	220000,
	315000,
	445000,
	635000,
	890000,
	1300000,
	1800000,
	2550000,
	3600000
]

var characters:Array=[] #该账号的已创建角色清单
var character:=Character.new() #该账号的已激活角色
var skills:Array=[] #该账号所有已创建角色的已学习技能
var learned_skills:Array=[] #该账号已激活角色的已学技能
var logged_in:bool=false
var tab:int=0

func to_character(o):
	var c=Character.new()
	c.character_name=o.character_name
	c.job=int(o.job)
	c.experience=int(o.experience)
	c.level=int(o.level)
	c.race=int(o.race)
	c.gender=int(o.gender)
	c.max_hp=int(o.max_hp)
	c.hp=int(o.hp)
	c.max_mana=int(o.max_mana)
	c.mana=int(o.mana)
	c.mana_regeneration=int(o.mana_regeneration)
	c.skill_points=int(o.skill_points)
	c.levelup_attribute_points=int(o.levelup_attribute_points)
	c.attributes={
		"str":int(o.attributes.str),
		"dex":int(o.attributes.dex),
		"con":int(o.attributes.con),
		"int":int(o.attributes.int),
		"wis":int(o.attributes.wis),
		"cha":int(o.attributes.cha)
	}
	c.initiative=int(o.initiative)
	c.armor_class=int(o.armor_class)
	c.base_attack_bonus=int(o.base_attack_bonus)
	c.before_turn_actions=int(o.before_turn_actions)
	c.actions=int(o.actions)
	c.after_turn_actions=int(o.after_turn_actions)
	c.active=int(o.active)
	return c

func to_character_storage_object(c:Character):
	var characterStorageObject={
		character_name=c.character_name,
		job=c.job,
		experience=c.experience,
		level=c.level,
		race=c.race,
		gender=c.gender,
		max_hp=c.max_hp,
		hp=c.hp,
		max_mana=c.max_mana,
		mana=c.mana,
		mana_regeneration=c.mana_regeneration,
		skill_points=c.skill_points,
		levelup_attribute_points=c.levelup_attribute_points,
		attributes=c.attributes,
		initiative=c.initiative,
		armor_class=c.armor_class,
		base_attack_bonus=c.base_attack_bonus,
		before_turn_actions=c.before_turn_actions,
		actions=c.actions,
		after_turn_actions=c.after_turn_actions,
		active=c.active
	}
	return characterStorageObject

func to_skill_storage_object(cname:String,cskills:Array):
	var skillStorageObject={
		character_name = cname,
		learned_skills = cskills
	}
	return skillStorageObject

func get_race_from_index(index):
	match index:
		races.HUMAN:
			return Human.new()
		races.DWARF:
			return Dwarf.new()
		races.ELF:
			return Elf.new()
		races.GNOME:
			return Gnome.new()
		races.HALF_ELF:
			return HalfElf.new()
		races.HALFLING:
			return Halfling.new()
		races.HALF_ORC:
			return HalfOrc.new()	
	return null

func translate_attribute_name(key):
	if key=="str":
		return "力量"
	if key=="dex":
		return "敏捷"
	if key=="con":
		return "体质"
	if key=="int":
		return "智力"
	if key=="wis":
		return "感知"
	if key=="cha":
		return "魅力"
	return "错误属性名"

func translate_attribute_name_from_number(key):
	if key==1:
		return "力量"
	if key==2:
		return "敏捷"
	if key==3:
		return "体质"
	if key==4:
		return "智力"
	if key==5:
		return "感知"
	if key==6:
		return "魅力"
	return "错误属性key"

func translate_skill_target_factor(factor):
	if factor==0:
		return "等级"
	if factor==1:
		return "力量"
	if factor==2:
		return "敏捷"
	if factor==3:
		return "体质"
	if factor==4:
		return "智力"
	if factor==5:
		return "感知"
	if factor==6:
		return "魅力"
	return "错误技能目标因子"

func translate_race(race):
	match race:
		races.HUMAN:
			return "人类"
		races.DWARF:
			return "矮人"
		races.ELF:
			return "精灵"
		races.GNOME:
			return "侏儒"
		races.HALF_ELF:
			return "半精灵"
		races.HALFLING:
			return "半身人"
		races.HALF_ORC:
			return "半兽人"
	return "错误种族"

func translate_job(job):
	match job:
		jobs.FIGHTER:
			return "战士"
		jobs.MAGE:
			return "法师"
		jobs.CLERIC:
			return "牧师"
	return "错误职业"

func get_job_from_index(index):
	match index:
		jobs.FIGHTER:
			return Fighter.new()
		jobs.MAGE:
			return Mage.new()
		jobs.CLERIC:
			return Cleric.new()
	return null

func get_skill_list(job_index):
	var skillDB:TextDatabase=load("res://skills/SkillDB.gd").new()
	skillDB.load_from_path("res://skills/misc/")
	match job_index:
		jobs.FIGHTER:
			skillDB.load_from_path("res://skills/fighter/")
		jobs.MAGE:
			skillDB.load_from_path("res://skills/mage/")
		jobs.CLERIC:
			skillDB.load_from_path("res://skills/cleric/")
	return skillDB

func translate_skill_type(type):
	if type==-1:
		return "被动技能"
	if type==0:
		return "武器技能"
	if type==1:
		return "魔法技能"
	return "错误技能类型"
		
func translate_skill_range(r):
	if r==-1:
		return "自身"
	if r==0:
		return "队友（含自身）"
	if r==1:
		return "近战"
	if r==2:
		return "远程"
	return "错误范围"

func translate_skill_turn_action(action):
	if action==-1:
		return "任意"
	if action==0:
		return "回合前"
	if action==1:
		return "回合中"
	if action==2:
		return "回合后"
	return "错误回合动作"
	
func translate_skill_effect_type(type):
	if type==-1:
		return "DEBUFF"
	if type==0:
		return "伤害"
	if type==1:
		return "BUFF"
	if type==2:
		return "治疗"
	return "错误技能效果类型"

func translate_skill_duration(duration):
	if duration==-1:
		return "整个地城"
	if duration==0:
		return "当前关卡"
	if duration>0:
		return str(duration)+"个回合"
	return "错误持续时间值"

func get_color_from_index(index):
	if index==-1:
		return Color.BLUE
	if index==0:
		return Color.DARK_BLUE
	if index==1:
		return Color.WEB_MAROON
	if index==2:
		return Color.DARK_GREEN
	if index==3:
		return Color.AZURE
	if index==4:
		return Color.DARK_ORANGE
	if index==5:
		return Color.DARK_GOLDENROD
	if index==6:
		return Color.BLUE_VIOLET
	if index==7:
		return Color.INDIAN_RED
	return Color.BLACK

func translate_debuff_buff_type(index):
	if index==-1:
		return "AC"
	if index==0:
		return "攻击加值"
	if index==1:
		return "力量"
	if index==2:
		return "敏捷"
	if index==3:
		return "体质"
	if index==4:
		return "智力"
	if index==5:
		return "感知"
	if index==6:
		return "魅力"
	if index==7:
		return "先攻加值"
	return "错误类型"

func get_color_from_damage_type(type):
	if type=="NEGATIVE":
		return Color.DIM_GRAY
	if type=="HOLY":
		return Color.LIGHT_GOLDENROD
	if type=="FIRE":
		return Color.ORANGE_RED
	if type=="FORCE":
		return Color.AQUA
	if type=="FROST":
		return Color.CORNFLOWER_BLUE
	if type=="WEAPON":
		return Color.CADET_BLUE
	return Color.BLACK

func translate_damage_type(type):
	if type=="NEGATIVE":
		return "负能量"
	if type=="HOLY":
		return "神圣"
	if type=="FIRE":
		return "火焰"
	if type=="FORCE":
		return "力场"
	if type=="FROST":
		return "寒霜"
	if type=="WEAPON":
		return "武器"
	return "错误伤害类型"

func checkString(string_to_check: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9_\u4e00-\u9fff]+$") # 此正则表达式允许字母、数字、下划线和中文字符
	return regex.search(string_to_check) != null

func get_attr_mod(attr):
	return floori((attr-10)/2.0)
	
func get_bt_actions(level):
	if level<10:
		return 1
	elif level<20:
		return 2
	else:
		return 3

func get_at_actions(level):
	if level<20:
		return 1
	else:
		return 2

func get_actions(bab):
	if bab<1:
		return 1
	else:
		return 1+floori(float(bab-1)/5.0)

func get_gender_text(index):
	if index==0:
		return "男性"
	if index==1:
		return "女性"
	return "性别错误"

func update_active_character_by_attributes():
	var job:Job=get_job_from_index(character.job)
	var race:Race=get_race_from_index(character.race)
	character.max_hp=job.hit_dice+\
		floori(MathUtil.calculate_mean(job.hit_dice)*float(character.level-1))+\
		character.level*get_attr_mod(character.attributes.con)
	character.hp=character.max_hp
	character.max_mana=job.l1_mana+\
		job.mana_increment*(character.level-1)+\
		get_attr_mod(character.attributes.int)*character.level
	character.mana=character.max_mana
	character.initiative=get_attr_mod(character.attributes.dex)+\
		race.bonus_initiative
	for skill in learned_skills:
		if skill.Skill_Index=="MISC-0":
			character.initiative+=2
	character.armor_class=10+get_attr_mod(character.attributes.dex)+race.bonus_ac

func update_active_character_by_levelup():
	var job:Job=get_job_from_index(character.job)
	character.level+=1
	character.max_hp=job.hit_dice+\
		floori(MathUtil.calculate_mean(job.hit_dice)*float(character.level-1))+\
		character.level*get_attr_mod(character.attributes.con)
	character.hp=character.max_hp
	character.max_mana=job.l1_mana+\
		job.mana_increment*(character.level-1)+\
		get_attr_mod(character.attributes.int)*character.level
	character.mana=character.max_mana
	character.skill_points=floori(float(job.l1_skill_points)+float(character.level-1)*job.skill_points_increment)
	if character.level % 4==0:
		character.levelup_attribute_points+=1
	character.base_attack_bonus=floori(float(job.l1_bab)+job.bab_increment*float(character.level-1))
	if job.job_index==ClientManager.jobs.FIGHTER:
		for skill in learned_skills:
			if skill.Skill_Index=="FIGHTER-2":
				character.base_attack_bonus+=2
	character.before_turn_actions=get_bt_actions(character.level)
	character.actions=get_actions(character.level)
	character.after_turn_actions=get_at_actions(character.level)
