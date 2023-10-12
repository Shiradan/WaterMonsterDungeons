extends Race
class_name Halfling

const halfling_bonus_attributes:Dictionary={
	"str":-2,
	"dex":2,
	"con":0,
	"int":0,
	"wis":0,
	"cha":2
}

func _init():
	self.cn_name="半身人"
	self.race_index=ClientManager.races.HALFLING
	self.desc=""
	self.bonus_attributes=halfling_bonus_attributes
	self.bonus_ab=1
	self.bonus_ac=1

