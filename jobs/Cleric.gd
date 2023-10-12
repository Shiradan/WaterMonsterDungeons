extends Job
class_name Cleric

func _init():
	self.job_index=ClientManager.jobs.CLERIC
	self.cn_name="牧师"
	self.desc=""
	self.hit_dice=8
	self.l1_bab=0
	self.bab_increment=0.75
	self.l1_mana=2
	self.mana_increment=12
	self.l1_skill_points=4
	self.skill_points_increment=1.5
