extends Job
class_name Fighter

const job_index=0

func _init():
	self.hit_dice=10
	self.l1_bab=1
	self.bab_increment=1.0
	self.l1_skill_points=3
	self.skill_points_increment=1.5