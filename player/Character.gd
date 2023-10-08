extends Node
class_name CharacterStats

var character_name:String="" : set=set_character_name
var job:int=-1 : set=set_job
var exp:int=0 : set=set_exp
var level:int=0 : set=set_level
var race:int=-1 : set=set_race
var gender:int=-1 : set=set_gender
var max_hp:int=0 : set=set_max_hp
var hp:int=max_hp : set=set_hp
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
var active:bool=false : set=set_active

func set_character_name(value):
	character_name=value

func set_job(value):
	job=value

func set_exp(value):
	exp=value

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

func set_attributes(value):
	attributes=value
	
func set_initiative(value):
	initiative=value
	
func set_armor_class(value):
	armor_class=value

func set_bab(value):
	base_attack_bonus=value 

func set_active(value):
	active=value
