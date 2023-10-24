extends HBoxContainer

func setup_skill_selections():
	var bt_skill_options:OptionButton=$BeforeTurnMarginContainer/BeforeTurnContainer/BeforeTurnPanel/BeforeTurnSkillChoiceContainer/BeforeTurnSkillOptionButton
	var it_skill_options:OptionButton=$InTurnContainer/InTurnContainer/InTurnPanel/InTurnSkillChoiceContainer/InTurnSkillOptionButton
	var at_skill_options:OptionButton=$AfterTurnMarginContainer/AfterTurnContainer/AfterTurnPanel/AfterTurnSkillChoiceContainer/AfterTurnSkillOptionButton

	while bt_skill_options.has_selectable_items():
		bt_skill_options.remove_item(0)
		
	while it_skill_options.has_selectable_items():
		it_skill_options.remove_item(0)
	
	while at_skill_options.has_selectable_items():
		at_skill_options.remove_item(0)
	
	for skill in ClientManager.learned_skills:
		if int(skill.Type)!=-1:
			if int(skill.TurnAction)==-1:
				bt_skill_options.add_item(skill.cn_name)
				it_skill_options.add_item(skill.cn_name)
				at_skill_options.add_item(skill.cn_name)
			elif int(skill.TurnAction)==0:
				bt_skill_options.add_item(skill.cn_name)
			elif int(skill.TurnAction)==1:
				it_skill_options.add_item(skill.cn_name)
			elif int(skill.TurnAction)==2:
				at_skill_options.add_item(skill.cn_name)
	
	bt_skill_options.add_item("等待")
	it_skill_options.add_item("等待")
	at_skill_options.add_item("等待")
	
	bt_skill_options.selected=-1
	it_skill_options.selected=-1
	at_skill_options.selected=-1

func setup_skill_order():
	var bt_skill_order=$BeforeTurnMarginContainer/BeforeTurnContainer/BeforeTurnPanel/BeforeTurnSkillScrollContainer/BeforeTurnSkillOrderContainer
	var it_skill_order=$InTurnContainer/InTurnContainer/InTurnPanel/InTurnSkillScrollContainer/InTurnSkillOrderContainer
	var at_skill_order=$AfterTurnMarginContainer/AfterTurnContainer/AfterTurnPanel/AfterTurnSkillScrollContainer/AfterTurnSkillOrderContainer
	for node in bt_skill_order.get_children():
		node.queue_free()
	for node in it_skill_order.get_children():
		node.queue_free()
	for node in at_skill_order.get_children():
		node.queue_free()

func _on_before_turn_add_skill_button_pressed():
	var bt_action_selected=$BeforeTurnMarginContainer/BeforeTurnContainer/BeforeTurnPanel/BeforeTurnSkillChoiceContainer/BeforeTurnSkillOptionButton
	var skillOrderContainer=$BeforeTurnMarginContainer/BeforeTurnContainer/BeforeTurnPanel/BeforeTurnSkillScrollContainer/BeforeTurnSkillOrderContainer
	var skillRow=load("res://main/main_game_scene_pages/tactic_skill_row.tscn").instantiate()
	if bt_action_selected.selected!=-1:
		skillRow.skill_name=bt_action_selected.get_item_text(bt_action_selected.selected)
		skillOrderContainer.add_child(skillRow)
		bt_action_selected.selected=-1

func _on_in_turn_add_skill_button_pressed():
	var it_action_selected=$InTurnContainer/InTurnContainer/InTurnPanel/InTurnSkillChoiceContainer/InTurnSkillOptionButton
	var skillOrderContainer=$InTurnContainer/InTurnContainer/InTurnPanel/InTurnSkillScrollContainer/InTurnSkillOrderContainer
	var skillRow=load("res://main/main_game_scene_pages/tactic_skill_row.tscn").instantiate()
	if it_action_selected.selected!=-1:
		skillRow.skill_name=it_action_selected.get_item_text(it_action_selected.selected)
		skillOrderContainer.add_child(skillRow)
		it_action_selected.selected=-1


func _on_after_turn_add_skill_button_pressed():
	var at_action_selected=$AfterTurnMarginContainer/AfterTurnContainer/AfterTurnPanel/AfterTurnSkillChoiceContainer/AfterTurnSkillOptionButton
	var skillOrderContainer=$AfterTurnMarginContainer/AfterTurnContainer/AfterTurnPanel/AfterTurnSkillScrollContainer/AfterTurnSkillOrderContainer
	var skillRow=load("res://main/main_game_scene_pages/tactic_skill_row.tscn").instantiate()
	if at_action_selected.selected!=-1:
		skillRow.skill_name=at_action_selected.get_item_text(at_action_selected.selected)
		skillOrderContainer.add_child(skillRow)
		at_action_selected.selected=-1
