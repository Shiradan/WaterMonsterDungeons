extends Node
class_name Race

var bonus_attributes:Dictionary={
	"str":0,
	"dex":0,
	"con":0,
	"int":0,
	"wis":0,
	"cha":0
} : set=set_bonus_attributes

var bonus_ac:int=0 : set=set_bonus_ac

var bonus_ab:int=0 : set=set_bonus_ab

var bonus_initiative:int=0 : set=set_bonus_initiative

func set_bonus_attributes(value):
	bonus_attributes=value

func set_bonus_ac(value):
	bonus_ac=value
	
func set_bonus_ab(value):
	bonus_ab=value

func set_bonus_initiative(value):
	bonus_initiative=value
