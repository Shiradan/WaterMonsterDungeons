extends Race
class_name Elf

const elf_bonus_attributes:Dictionary={
	"str":0,
	"dex":2,
	"con":-2,
	"int":2,
	"wis":0,
	"cha":0
}

func _init():
	self.cn_name="精灵"
	self.race_index=ClientManager.races.ELF
	self.desc=""
	self.bonus_attributes=elf_bonus_attributes
