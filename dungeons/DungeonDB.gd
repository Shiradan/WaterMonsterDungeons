extends TextDatabase

func _initialize():
	#地城索引
	add_mandatory_property("Dungeon_Index",TYPE_FLOAT)
	#中文名——必要
	add_mandatory_property("cn_name",TYPE_STRING)
	#地城描述——必要
	add_mandatory_property("Desc",TYPE_STRING)
	#各层战斗配置
	add_mandatory_property("Levels",TYPE_ARRAY)
	#胜利文本
	add_valid_property("victory_desc",TYPE_STRING)
	#失败文本
	add_valid_property("defeat_desc",TYPE_STRING)
	#怪物平均等级
	add_valid_property("CR",TYPE_FLOAT)
