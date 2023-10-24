extends Panel

@onready var levelTabContainer:TabContainer=$LevelTabContainer

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
	levelTabContainer.move_child(newTab,-3)
	levelTabContainer.current_tab=levelTabContainer.get_tab_idx_from_control(newTab)

func setup_tactic_setting_page():
	setup_tactic_saves()
	setup_action_panel()

func setup_tactic_saves():
	var tacticSavesOption=$TacticSavesContainer/TacticSavesOptionButton
	tacticSavesOption.add_item("创建新战术")
	if ClientManager.tactic_settings.size()>0:
		for tactic_setting in ClientManager.tactic_settings:
			tacticSavesOption.add_item(tactic_setting.tactic_name)
	tacticSavesOption.selected=-1

func setup_action_panel():
	var defaultTacticPanel=$"LevelTabContainer/默认"
	defaultTacticPanel.setup_skill_selections()
	defaultTacticPanel.setup_skill_order()	
	

func _on_tactic_saves_option_button_item_selected(index):
	if index==0: #创建新战术
		var tacticSaveNameWindow=load("res://main/main_game_scene_pages/tactic_save_popup_window.tscn").instantiate()
		tacticSaveNameWindow.name_entered.connect(get_tactic_name)
		$".".add_child(tacticSaveNameWindow)
	else:
		load_tactic_save(index)

func get_tactic_name():
	var popupWindow=$".".get_child(-1)
	var tacticName=popupWindow.text
	popupWindow.queue_free()
	var tacticSavesOption=$TacticSavesContainer/TacticSavesOptionButton
	tacticSavesOption.add_item(tacticName)
	tacticSavesOption.selected=ClientManager.tactic_settings.size()+1

func load_tactic_save(index:int):
	pass
