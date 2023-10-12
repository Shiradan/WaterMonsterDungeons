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

var characters:Array=[]
var character:=Character.new()

func to_character_object(s):
	var c=Character.new()
	return c

func get_race_from_index(index):
	var race:Race=Race.new()
	match index:
		races.HUMAN:
			race=Human.new()
		races.DWARF:
			race=Dwarf.new()
		races.ELF:
			race=Elf.new()
		races.GNOME:
			race=Gnome.new()
		races.HALF_ELF:
			race=HalfElf.new()
		races.HALFLING:
			race=Halfling.new()
		races.HALF_ORC:
			race=HalfOrc.new()
			
	return race

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

func translate_job(job):
	match job:
		jobs.FIGHTER:
			return "战士"
		jobs.MAGE:
			return "法师"
		jobs.CLERIC:
			return "牧师"

func get_job_from_index(index):
	var job:Job=Job.new()
	match index:
		jobs.FIGHTER:
			job=Fighter.new()
		jobs.MAGE:
			job=Mage.new()
		jobs.CLERIC:
			job=Cleric.new()
	return job

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
