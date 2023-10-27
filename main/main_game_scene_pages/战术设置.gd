extends Panel

@onready var levelTabContainer:TabContainer=$LevelTabContainer

var is_new_tactic:bool=false

func _process(_delta):
	if levelTabContainer.get_tab_idx_from_control($"LevelTabContainer/默认")!=0:
		levelTabContainer.move_child($"LevelTabContainer/默认",0)
	if levelTabContainer.get_tab_idx_from_control($"LevelTabContainer/+")!=levelTabContainer.get_tab_count()-2:
		levelTabContainer.move_child($"LevelTabContainer/+",levelTabContainer.get_tab_count()-2)
	if levelTabContainer.get_tab_idx_from_control($"LevelTabContainer/-")!=levelTabContainer.get_tab_count()-1:
		levelTabContainer.move_child($"LevelTabContainer/-",levelTabContainer.get_tab_count()-1)

func _on_level_tab_container_tab_clicked(tab):
	var previousTab=levelTabContainer.get_previous_tab()
	if levelTabContainer.get_tab_title(tab)=="+":
		levelTabContainer.current_tab=previousTab
		var levelPopupWindow:PopupPanel=load("res://main/main_game_scene_pages/level_number_popup_panel.tscn").instantiate()
		levelPopupWindow.level_entered.connect(get_level_number_entered)
		$".".add_child(levelPopupWindow)
		levelPopupWindow.popup_centered()
	if levelTabContainer.get_tab_title(tab)=="-":
		if levelTabContainer.get_tab_count()>3:
			if previousTab!=0:
				levelTabContainer.get_tab_control(previousTab).queue_free()
				levelTabContainer.current_tab=previousTab-1
		
func get_level_number_entered():
	var popupWindow=$".".get_child(-1)
	var levelNo=popupWindow.text
	popupWindow.queue_free()
	levelTabContainer.add_child(load("res://main/main_game_scene_pages/turn_action_container.tscn").instantiate())
	var newTab=levelTabContainer.get_tab_control(levelTabContainer.get_tab_count()-1)
	newTab.name=levelNo
	newTab.setup_skill_selections()
	levelTabContainer.move_child(newTab,-3)
	levelTabContainer.current_tab=levelTabContainer.get_tab_idx_from_control(newTab)

func setup_tactic_setting_page():
	setup_tactic_saves()
	reset()


func setup_tactic_saves():
	var tacticSavesOption:OptionButton=$TacticSavesContainer/TacticSavesOptionButton
	while tacticSavesOption.has_selectable_items():
		tacticSavesOption.remove_item(0)
	tacticSavesOption.add_item("创建新战术")
	if ClientManager.tactic_settings.size()>0:
		for tactic_setting in ClientManager.tactic_settings:
			tacticSavesOption.add_item(tactic_setting.tactic_name)
	tacticSavesOption.selected=-1

func setup_action_panel():
	var defaultTacticPanel=$"LevelTabContainer/默认"
	defaultTacticPanel.setup_skill_selections()
	defaultTacticPanel.setup_default_skill_order()	
	

func _on_tactic_saves_option_button_item_selected(index):
	if index==0: #创建新战术
		is_new_tactic=true
		var tacticSaveNameWindow:PopupPanel=load("res://main/main_game_scene_pages/tactic_save_popup_window.tscn").instantiate()
		tacticSaveNameWindow.name_entered.connect(get_tactic_name)
		$".".add_child(tacticSaveNameWindow)
		tacticSaveNameWindow.popup_centered()
	else:
		is_new_tactic=false
		load_tactic_save(index)

func get_tactic_name():
	var popupWindow=$".".get_child(-1)
	var tacticName=popupWindow.text
	popupWindow.queue_free()
	var tacticSavesOption=$TacticSavesContainer/TacticSavesOptionButton
	tacticSavesOption.add_item(tacticName)
	tacticSavesOption.selected=ClientManager.tactic_settings.size()+1
	reset()

func load_tactic_save(index:int):
	reset()
	var tacticSave=ClientManager.tactic_settings[index-1]
	$ScrollContainer/VBoxContainer/PositionContainer/PostionOptionButton.selected=tacticSave.position
	$ScrollContainer/VBoxContainer/AutoHealContainer/AutoHealOptionButton.selected=tacticSave.auto_heal
	$ScrollContainer/VBoxContainer/RetreatContainer/RetreatOptionButton.selected=tacticSave.auto_retreat
	
	for level in tacticSave.levels:
		if int(level.level)==0:
			levelTabContainer.get_tab_control(0).setup_skill_order_by_level(level)
		else:
			levelTabContainer.add_child(load("res://main/main_game_scene_pages/turn_action_container.tscn").instantiate())
			var newTab=levelTabContainer.get_tab_control(levelTabContainer.get_tab_count()-1)
			newTab.name=str(level.level)
			newTab.setup_skill_selections()
			levelTabContainer.move_child(newTab,-3)
			newTab.setup_skill_order_by_level(level)


func _on_save_tactic_pressed():
	if $TacticSavesContainer/TacticSavesOptionButton.selected==-1:
		var tacticSaveNameWindow=load("res://main/main_game_scene_pages/tactic_save_popup_window.tscn").instantiate()
		tacticSaveNameWindow.name_entered.connect(get_tactic_name_save)
		$".".add_child(tacticSaveNameWindow)
		tacticSaveNameWindow.popup_centered()
	else:
		save_tactic_setting()

func get_tactic_name_save():
	var popupWindow=$".".get_child(-1)
	var tacticName=popupWindow.text
	popupWindow.queue_free()
	var tacticSavesOption=$TacticSavesContainer/TacticSavesOptionButton
	tacticSavesOption.add_item(tacticName)
	tacticSavesOption.selected=ClientManager.tactic_settings.size()+1
	save_tactic_setting()

func save_tactic_setting():
	var tacticSaveOptions:OptionButton=$TacticSavesContainer/TacticSavesOptionButton
	var postionOptions:OptionButton=$ScrollContainer/VBoxContainer/PositionContainer/PostionOptionButton
	var autoHealOptions:OptionButton=$ScrollContainer/VBoxContainer/AutoHealContainer/AutoHealOptionButton
	var autoRetreatOptions:OptionButton=$ScrollContainer/VBoxContainer/RetreatContainer/RetreatOptionButton
	if is_new_tactic:
		var levels=[]
		var i=0
		while i<levelTabContainer.get_tab_count()-2:
			var tab=levelTabContainer.get_tab_control(i)
			var level={
				"level":i,
				"before_turn":tab.get_bt_actions(),
				"in_turn":tab.get_it_actions(),
				"after_turn":tab.get_at_actions()
			}
			#获取每个tab的bt、it、at行动列表
			levels.append(level)
			i+=1
		var tactic_setting={
			"tactic_name":tacticSaveOptions.get_item_text(tacticSaveOptions.selected),
			"position":postionOptions.selected,
			"auto_heal":autoHealOptions.selected,
			"auto_retreat":autoRetreatOptions.selected,
			"levels":levels
		}
		if ClientManager.tactic_settings.size()>0:
			var tacticsArray=[]
			ClientManager.tactic_settings.append(tactic_setting)
			for t in ClientManager.tactics:
				if t.character_name==ClientManager.character.character_name:
					var tactic={
						"character_name":ClientManager.character.character_name,
						"tactic_settings":ClientManager.tactic_settings
					}
					t=tactic
				tacticsArray.append(t)
			ClientManager.tactics=tacticsArray
		else:
			ClientManager.tactic_settings.append(tactic_setting)
			var tactic={
				"character_name":ClientManager.character.character_name,
				"tactic_settings":ClientManager.tactic_settings
			}
			ClientManager.tactics.append(tactic)

	else:
		var levels=[]
		var i=0
		while i<levelTabContainer.get_tab_count()-2:
			var tab=levelTabContainer.get_tab_control(i)
			var level={
				"level":i,
				"before_turn":tab.get_bt_actions(),
				"in_turn":tab.get_it_actions(),
				"after_turn":tab.get_at_actions()
			}
			#获取每个tab的bt、it、at行动列表
			levels.append(level)
			i+=1
		var tactic_setting={
			"tactic_name":tacticSaveOptions.get_item_text(tacticSaveOptions.selected),
			"position":postionOptions.selected,
			"auto_heal":autoHealOptions.selected,
			"auto_retreat":autoRetreatOptions.selected,
			"levels":levels
		}
		var tacticSettingsArray=[]
		for ts in ClientManager.tactic_settings:
			if ts.tactic_name==tactic_setting.tactic_name:
				ts=tactic_setting
			tacticSettingsArray.append(ts)
		ClientManager.tactic_settings=tacticSettingsArray
		var tacticsArray=[]
		for t in ClientManager.tactics:
			if t.character_name==ClientManager.character.character_name:
				var tactic={
					"character_name":ClientManager.character.character_name,
					"tactic_settings":ClientManager.tactic_settings
				}
				t=tactic
			tacticsArray.append(t)
		ClientManager.tactics=tacticsArray
	#write tactics to nakama server
	await ServerConnection.write_tactics_async(ClientManager.tactics)
	is_new_tactic=false

func reset():
	$ScrollContainer/VBoxContainer/PositionContainer/PostionOptionButton.selected=0
	$ScrollContainer/VBoxContainer/AutoHealContainer/AutoHealOptionButton.selected=1
	$ScrollContainer/VBoxContainer/RetreatContainer/RetreatOptionButton.selected=0
	#clean tabs from index 1
	while levelTabContainer.get_tab_count()>3:
		levelTabContainer.remove_child(levelTabContainer.get_tab_control(1))
	setup_action_panel()


func _on_delete_tactic_pressed():
	var tacticOptions:OptionButton=$TacticSavesContainer/TacticSavesOptionButton
	if tacticOptions.selected!=-1:
		var deleteConfirmWindow:PopupPanel=load("res://main/main_game_scene_pages/delete_tactic_popup_window.tscn").instantiate()
		deleteConfirmWindow.confirm_delete.connect(get_delete_confirmation)
		$".".add_child(deleteConfirmWindow)
		deleteConfirmWindow.popup_centered()
		
func get_delete_confirmation():
	var tacticOptions:OptionButton=$TacticSavesContainer/TacticSavesOptionButton
	await ClientManager.delete_tactic(tacticOptions.get_item_text(tacticOptions.selected))
	tacticOptions.selected=-1
	reset()
	setup_tactic_saves()
