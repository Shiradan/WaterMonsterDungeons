extends Node
class_name Job

var job_index:int=0 : set=set_job_index
var cn_name:String="" : set=set_cn_name
var desc:String="" : set=set_desc
var hit_dice:int=0 : set=set_hit_dice
var l1_bab:int=0 : set=set_l1_bab
var bab_increment:float=0.0 : set=set_bab_increment
var l1_mana:int=0 : set=set_l1_mana
var mana_increment:int=0 : set=set_mana_increment
var l1_skill_points:int=0 : set=set_l1_skill_points
var skill_points_increment:float=0.0 : set=set_skill_points_increment

func set_job_index(value):
	job_index=value

func set_cn_name(value):
	cn_name=value

func set_desc(value):
	desc=value

func set_hit_dice(value):
	hit_dice=value

func set_l1_bab(value):
	l1_bab=value
	
func set_bab_increment(value):
	bab_increment=value

func set_l1_mana(value):
	l1_mana=value

func set_mana_increment(value):
	mana_increment=value

func set_l1_skill_points(value):
	l1_skill_points=value

func set_skill_points_increment(value):
	skill_points_increment=value
