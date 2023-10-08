extends Job
class_name Cleric

const job_index=2

func _init():
	self.hit_dice=8
	self.l1_bab=0
	self.bab_increment=0.75
	self.l1_skill_points=4
	self.skill_points_increment=1.5
