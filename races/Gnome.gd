extends Race
class_name Gnome

const gnome_bonus_attributes:Dictionary={
	"str":-2,
	"dex":0,
	"con":2,
	"int":0,
	"wis":0,
	"cha":2
}

func _init():
	self.cn_name="侏儒"
	self.race_index=ClientManager.races.GNOME
	self.desc=""
	self.bonus_attributes=gnome_bonus_attributes
	self.bonus_ac=4
