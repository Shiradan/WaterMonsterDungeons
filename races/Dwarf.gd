extends Race
class_name Dwarf

const dwarf_bonus_attributes:Dictionary={
	"str":0,
	"dex":0,
	"con":2,
	"int":0,
	"wis":2,
	"cha":-2
}

func _init():
	self.cn_name="矮人"
	self.race_index=ClientManager.races.DWARF
	self.desc=""
	self.bonus_attributes=dwarf_bonus_attributes
	self.bonus_ac=4
	self.bonus_ab=1
