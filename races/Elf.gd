extends Race
class_name Elf

const race_index:int=2
const cn_name:String="精灵"
const elf_bonus_attributes:Dictionary={
	"str":0,
	"dex":2,
	"con":-2,
	"int":2,
	"wis":0,
	"cha":0
}

func _init():
	self.bonus_attributes=elf_bonus_attributes
