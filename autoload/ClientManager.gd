extends Node

enum races {
	HUMAN,
	DWARF,
	ELF,
	GNOME,
	HALF_ELF,
	HALFLING,
	HALF_ORC
}

enum jobs {
	FIGHTER,
	MAGE,
	CLERIC
}

var characters:Array=[]
var character:=Character.new()
var skillDB:TextDatabase=null

func to_character_object(s):
	var c=Character.new()
	return c


