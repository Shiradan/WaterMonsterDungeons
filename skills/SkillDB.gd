extends TextDatabase

func _initialize():
	add_mandatory_property("Skill_Index",TYPE_STRING)
	#中文名——必要
	add_mandatory_property("cn_name",TYPE_STRING)
	#技能描述——必要
	add_mandatory_property("Desc",TYPE_STRING)
	#必要学习等级（必要）
	add_mandatory_property("LevelRequired",TYPE_FLOAT)
	#前置技能要求（非必要）
	add_valid_property("PreSkill",TYPE_STRING)
	#角色是否已学（必要），0：未学习，1：已学习
	add_mandatory_property("Learned",TYPE_FLOAT)
	#技能大类（必要）——-1：被动技能，0：weapon技能，1：魔法技能
	add_mandatory_property("Type",TYPE_FLOAT)
	#技能范围（必要）——-1：自身，0：队友（含自己），1：近战，2：远程
	add_mandatory_property("Range",TYPE_FLOAT)
	#技能释放回合动作（必要）——-1：任意，0：回合前，1：回合中，2：回合后
	add_mandatory_property("TurnAction",TYPE_FLOAT)
	#每次释放技能的魔力消耗值
	add_valid_property("Mana",TYPE_FLOAT)
	#命中替换属性（非必要，一般来说武器技能命中属性为力量（近战）或敏捷（远程），魔法技能命中属性为智力，此项用于替换原命中属性）——1：力量、2：敏捷:3：体质:4：智力:5：感知:6：魅力
	add_valid_property("AttackAttribute",TYPE_FLOAT)
	#伤害替换属性（非必要，一般来说武器技能伤害属性为力量，魔法技能伤害属性为智力，此项用于替换原伤害属性）——1：力量、2：敏捷:3：体质:4：智力:5：感知:6：魅力
	add_valid_property("DamageAttribute",TYPE_FLOAT)
	#影响数量（必要）——-1：动态数量，0：全部，1+：固定数量
	add_mandatory_property("Target",TYPE_FLOAT)
	#影响数量乘数（非必要），需要带小数点的浮点数
	add_valid_property("TargetMultiplier",TYPE_FLOAT)
	#影响数量因子（非必要）——0：等级、1：力量、2：敏捷:3：体质:4：智力:5：感知:6：魅力
	add_valid_property("TargetFactor",TYPE_FLOAT)
	#效果类型（必要）——-1：DEBUFF，0：伤害，1：BUFF，2：治疗
	add_mandatory_property("EffectType",TYPE_FLOAT)
	#固定伤害值数组（非必要）,数组中的每个元素需要包含伤害类型（DamageType），伤害值（DamageValue）
	add_valid_property("DamageValueArray",TYPE_ARRAY)
	#伤害骰子数组（非必要），需要包含DamageType，DamageDice（骰子面数），DamageDiceNo（骰子数量）
	add_valid_property("DamageDiceArray",TYPE_ARRAY)
	#固定治疗数值（非必要）
	add_valid_property("HealValue",TYPE_FLOAT)
	#治疗骰子面数（非必要）
	add_valid_property("HealDice",TYPE_FLOAT)
	#治疗骰子数（非必要）
	add_valid_property("HealDiceNo",TYPE_FLOAT)
	#固定BUFF数组（非必要），需要包含BuffType（buff类型，-1：AC、0：AB，1-6：六个属性,7:先攻），BuffValue（buff数值）
	add_valid_property("BuffValueArray",TYPE_ARRAY)
	#BUFF骰子数组（非必要），需要包含BuffType，BuffDice，BuffNo
	add_valid_property("BuffDiceArray",TYPE_ARRAY)
	#固定DEBUFF数组（非必要），需要包含DebuffType（debuff类型，-1：AC、0：AB，1-6：六个属性），DebuffValue（debuff数值）
	add_valid_property("DebuffValueArray",TYPE_ARRAY)
	#DEBUFF骰子数组（非必要），需要包含debuffType，debuffDice，debuffNo
	add_valid_property("DebuffDiceArray",TYPE_ARRAY)
	#效果持续时间（非必要）,-1:整个地城，0：当前层，1+：回合数
	add_valid_property("Duration",TYPE_FLOAT)
	
	
