extends Race
class_name Human

func _init():
	self.bonus_attribute_points=2
	self.bonus_skill_points=2
	self.cn_name="人类"
	self.race_index=ClientManager.races.HUMAN
	self.desc=""
