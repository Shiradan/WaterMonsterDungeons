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

var character=Character.new()
var skillDB:TextDatabase=null



