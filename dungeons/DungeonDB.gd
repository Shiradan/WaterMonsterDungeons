extends TextDatabase

func _initialize():
	#地城索引
	add_mandatory_property("Skill_Index",TYPE_FLOAT)
	#中文名——必要
	add_mandatory_property("cn_name",TYPE_STRING)
	#地城描述——必要
	add_mandatory_property("Desc",TYPE_STRING)
