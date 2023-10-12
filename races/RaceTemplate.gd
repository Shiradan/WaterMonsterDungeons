extends Node
class_name Race

var race_index:int=-1 : set=set_race_index
var cn_name:String="" : set=set_cn_name
var desc:String="" : set=set_desc
var bonus_attributes:Dictionary : set=set_bonus_attributes

var bonus_ac:int=0 : set=set_bonus_ac

var bonus_ab:int=0 : set=set_bonus_ab

var bonus_initiative:int=0 : set=set_bonus_initiative

var bonus_attribute_points:int=0 : set=set_bonus_attribute_points

var bonus_skill_points:int=0 : set=set_bonus_skill_points

func set_race_index(value):
	race_index=value

func set_cn_name(value):
	cn_name=value

func set_desc(value):
	desc=value

func set_bonus_attributes(value):
	bonus_attributes=value

func set_bonus_ac(value):
	bonus_ac=value
	
func set_bonus_ab(value):
	bonus_ab=value

func set_bonus_initiative(value):
	bonus_initiative=value

func set_bonus_attribute_points(value):
	bonus_attribute_points=value

func set_bonus_skill_points(value):
	bonus_skill_points=value
