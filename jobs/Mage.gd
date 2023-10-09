extends Job
class_name Mage

const job_index:int=1
const cn_name:String="法师"

func _init():
	self.hit_dice=6
	self.l1_bab=0
	self.bab_increment=0.5
	self.l1_mana=2
	self.mana_increment=12
	self.l1_skill_points=4
	self.skill_points_increment=1.5
