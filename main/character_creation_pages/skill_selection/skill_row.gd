extends VBoxContainer

var skillItem:Dictionary={} : set=set_skill_item
signal checked
signal unchecked
@onready var skillDesc=$SkillDesc

func set_skill_item(skill):
	skillItem=skill

func _on_toggle_skill_desc_button_toggled(button_pressed):
	skillDesc.clear()
	if !button_pressed:
		skillDesc.fit_content=false
	else:
		skillDesc.fit_content=true
		if skillItem.size()>0:
			setup_skill_desc(skillItem)
			

func setup_skill_desc(skill:Dictionary):
	skillDesc.append_text(
		"[color=#%s]技能说明[/color]: %s\n"
		% [Color.BLUE.to_html(false), skill.Desc]
	)
	skillDesc.append_text(
		"[color=#%s]学习等级[/color]: %s\n"
		% [Color.BLUE.to_html(false), skill.LevelRequired]
	)
	if skill.has("PreSkill"):
		skillDesc.append_text(
			"[color=#%s]前置技能[/color]: %s\n"
			% [Color.BLUE.to_html(false), skill.PreSkill]
		)
	skillDesc.append_text(
		"[color=#%s]技能分类[/color]: %s\n"
		% [Color.BLUE.to_html(false), ClientManager.translate_skill_type(skill.Type)]
	)
	skillDesc.append_text(
		"[color=#%s]技能范围[/color]: %s\n"
		% [Color.BLUE.to_html(false), ClientManager.translate_skill_range(skill.Range)]
	)
	if skill.Type!=-1:
		skillDesc.append_text(
			"[color=#%s]技能释放回合动作[/color]: %s\n"
			% [Color.BLUE.to_html(false), ClientManager.translate_skill_turn_action(skill.TurnAction)]
		)
	if skill.has("Mana"):
		skillDesc.append_text(
			"[color=#%s]使用技能消耗魔法值[/color]: %s\n"
			% [Color.BLUE.to_html(false), skill.Mana]
		)
	if skill.has("AttackAttribute"):
		skillDesc.append_text(
			"[color=#%s]攻击关联属性替换[/color]: %s\n"
			% [Color.BLUE.to_html(false), ClientManager.translate_attribute_name_from_number(skill.AttackAttribute)]
		)
	if skill.has("DamageAttribute"):
		skillDesc.append_text(
			"[color=#%s]伤害关联属性替换[/color]: %s\n"
			% [Color.BLUE.to_html(false), ClientManager.translate_attribute_name_from_number(skill.DamageAttribute)]
		)
	if skill.Type!=-1:
		if skill.Target!=-1:
			skillDesc.append_text(
				"[color=#%s]目标数量[/color]: %s\n"
				% [Color.BLUE.to_html(false), skill.Target]
			)
		else:
			skillDesc.append_text(
				"[color=#%s]目标数量[/color]: %s * %s\n"
				% [Color.BLUE.to_html(false), skill.TargetMultiplier, ClientManager.translate_skill_target_factor(skill.TargetFactor)]
			)
	skillDesc.append_text(
		"[color=#%s]技能效果类型[/color]: %s\n"
		% [Color.BLUE.to_html(false), ClientManager.translate_skill_effect_type(skill.EffectType)]
	)
	if skill.has("Duration"):
		skillDesc.append_text(
			"[color=#%s]技能效果持续时间[/color]: %s\n"
			% [Color.BLUE.to_html(false), ClientManager.translate_skill_duration(skill.Duration)]
		)
	if skill.EffectType==-1:
		skillDesc.append_text(
			"[color=#%s]DEBUFF效果[/color]:\n"
			% [Color.BLUE.to_html(false)]
		)
		if skill.has("DebuffDiceArray"):
			var debuffDiceArray=skill.DebuffDiceArray
			for debuffDice in debuffDiceArray:
				if debuffDice.has("DebuffDice") and debuffDice.has("DebuffDiceNo") and debuffDice.has("DebuffType"):
					skillDesc.append_text(
						"\t[color=#%s]- %s[/color]: %sD%s\n"
						% [ClientManager.get_color_from_index(debuffDice.DebuffType).to_html(false),
						ClientManager.translate_debuff_buff_type(debuffDice.DebuffType),
						debuffDice.DebuffDiceNo, debuffDice.DebuffDice]
					)
		if skill.has("DebuffValueArray"):
			var debuffValueArray=skill.DebuffValueArray
			for debuffValue in debuffValueArray:
				if debuffValue.has("DebuffValue") and debuffValue.has("DebuffType"):
					skillDesc.append_text(
						"\t[color=#%s]- %s[/color]: %s\n"
						% [ClientManager.get_color_from_index(debuffValue.DebuffType).to_html(false),
						ClientManager.translate_debuff_buff_type(debuffValue.DebuffType),
						debuffValue.DebuffValue]
					)
	if skill.EffectType==0:
		skillDesc.append_text(
			"[color=#%s]伤害效果[/color]:\n"
			% [Color.BLUE.to_html(false)]
		)
		if skill.has("DamageDiceArray"):
			var damageDiceArray=skill.DamageDiceArray
			for damageDice in damageDiceArray:
				if damageDice.has("DamageDice") and damageDice.has("DamageDiceNo") and damageDice.has("DamageType"):
					skillDesc.append_text(
						"\t- %sD%s [color=#%s]%s[/color] 伤害\n"
						% [damageDice.DamageDiceNo, damageDice.DamageDice,
						ClientManager.get_color_from_damage_type(damageDice.DamageType).to_html(false),
						ClientManager.translate_damage_type(damageDice.DamageType)]
					)
		if skill.has("DamageValueArray"):
			var damageValueArray=skill.DamageValueArray
			for damageValue in damageValueArray:
				if damageValue.has("DamageValue") and damageValue.has("DamageType"):
					skillDesc.append_text(
						"\t- %s点 [color=#%s]%s[/color] 伤害\n"
						% [damageValue.DamageValue,
						ClientManager.get_color_from_damage_type(damageValue.DamageType).to_html(false),
						ClientManager.trasnslate_damage_type(damageValue.DamageType)]
					)
	if skill.EffectType==1:
		skillDesc.append_text(
			"[color=#%s]BUFF效果[/color]:\n"
			% [Color.BLUE.to_html(false)]
		)
		if skill.has("BuffDiceArray"):
			var buffDiceArray=skill.BuffDiceArray
			for buffDice in buffDiceArray:
				if buffDice.has("BuffDice") and buffDice.has("BuffDiceNo") and buffDice.has("BuffType"):
					skillDesc.append_text(
						"\t[color=#%s]- %s[/color]: %sD%s\n"
						% [ClientManager.get_color_from_index(buffDice.BuffType).to_html(false),
						ClientManager.translate_debuff_buff_type(buffDice.BuffType),
						buffDice.BuffDiceNo, buffDice.BuffDice]
					)
		if skill.has("BuffValueArray"):
			var buffValueArray=skill.BuffValueArray
			for buffValue in buffValueArray:
				if buffValue.has("BuffValue") and buffValue.has("BuffType"):
					skillDesc.append_text(
						"\t[color=#%s]- %s[/color]: %s\n"
						% [ClientManager.get_color_from_index(buffValue.BuffType).to_html(false),
						ClientManager.translate_debuff_buff_type(buffValue.BuffType),
						buffValue.BuffValue]
					)
	if skill.EffectType==2:
		skillDesc.append_text(
			"[color=#%s]治疗效果[/color]:"
			% [Color.BLUE.to_html(false)]
		)
		if skill.has("HealDice") and skill.has("HealDiceNo"):
			skillDesc.append_text(
				"%sD%s"
				% [skill.HealDiceNo,skill.HealDice]
			)
			if skill.has("HealValue"):
				skillDesc.append_text(
					"+%s"
					% [skill.HealValue]
				)
		elif skill.has("HealValue"):
			skillDesc.append_text(
				"%s"
				% [skill.HealValue]
			)
		skillDesc.append_text("\n")	


func _on_skill_check_box_toggled(button_pressed):
		if button_pressed:
			emit_signal("checked")
		else:
			emit_signal("unchecked")
		
