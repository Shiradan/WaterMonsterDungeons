extends Node
class_name Character

var character_name:String="" : set=set_character_name
var job:int=-1 : set=set_job
var experience:int=0 : set=set_exp
var level:int=0 : set=set_level
var race:int=-1 : set=set_race
var gender:int=-1 : set=set_gender
var max_hp:int=0 : set=set_max_hp
var hp:int=max_hp : set=set_hp
var max_mana:int=0 : set=set_max_mana
var mana:int=max_mana : set=set_mana
var mana_regeneration:int : set=set_mana_regeneration
var skill_points:int=0 : set=set_skill_points
var levelup_attribute_points:int=0 : set=set_levelup_attribute_points
#var damage_reduction:int
var attributes:Dictionary = {
	"str":0,
	"dex":0,
	"con":0,
	"int":0,
	"wis":0,
	"cha":0
} : set=set_attributes
var initiative:int=0 : set=set_initiative
var armor_class:int=10 : set=set_armor_class
#var savings:Dictionary
var base_attack_bonus:int=0 : set=set_bab
#var spell_resistance:Dictionary
var before_turn_actions:int=0 : set=set_before_turn_actions
var actions:int=0 : set=set_actions
var after_turn_actions:int=0 : set=set_after_turn_actions
var active:int=0 : set=set_active

func set_character_name(value):
	character_name=value

func set_job(value):
	job=value

func set_exp(value):
	experience=value

func set_level(value):
	level=value

func set_race(value):
	race=value

func set_gender(value):
	gender=value

func set_max_hp(value):
	max_hp=value

func set_hp(value):
	hp=value

func set_max_mana(value):
	max_mana=value

func set_mana(value):
	mana=value

func set_mana_regeneration(value):
	mana_regeneration=value

func set_skill_points(value):
	skill_points=value

func set_levelup_attribute_points(value):
	levelup_attribute_points=value

func set_attributes(value):
	attributes=value
	
func set_initiative(value):
	initiative=value
	
func set_armor_class(value):
	armor_class=value

func set_bab(value):
	base_attack_bonus=value 

func set_before_turn_actions(value):
	before_turn_actions=value

func set_actions(value):
	actions=value

func set_after_turn_actions(value):
	after_turn_actions=value

func set_active(value):
	active=value
