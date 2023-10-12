extends Race
class_name HalfOrc

const halforc_bonus_attributes:Dictionary={
	"str":2,
	"dex":2,
	"con":2,
	"int":-2,
	"wis":0,
	"cha":-2
}

func _init():
	self.cn_name="半兽人"
	self.race_index=ClientManager.races.HALF_ORC
	self.desc=""
	self.bonus_attributes=halforc_bonus_attributes
	self.bonus_ab=1
	self.bonus_ac=1
