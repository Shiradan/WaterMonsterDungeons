extends Control

var skillList:TextDatabase=null : set=set_skillList
var skillPoints:int=0: set=set_skill_points
@onready var skillsContainer=$Panel/ScrollContainer/SkillsContainer
@onready var skillPointsContainerValue=$Panel/SkillPointsContainer/SkillPoints

func set_skillList(list):
	skillList=list

func set_skill_points(points):
	skillPoints=points

func reset():
	skillList=null
	skillPoints=0
	skillPointsContainerValue.text="0"
	for node in skillsContainer.get_children():
		node.queue_free()
	

func setup_skill_list():
	var skillArray=skillList.get_array()
	skillPointsContainerValue.text=str(skillPoints)
	for skill in skillArray:
		var skillRow:VBoxContainer=load("res://main/character_creation_pages/skill_selection/skill_row.tscn").instantiate()
		skillRow.skillItem=skill
		if skill.LevelRequired==1:
			var skillCheckbox=skillRow.get_child(0).get_child(0)
			skillCheckbox.text=skill.cn_name
			skillsContainer.add_child(skillRow)
			skillRow.checked.connect(on_checked)
			skillRow.unchecked.connect(on_unchecked)

func on_checked():
	if skillPoints>0:
		skillPoints-=1
		skillPointsContainerValue.text=str(skillPoints)
	if skillPoints==0:
		for skillRow in skillsContainer.get_children():
			var skillCheckBox:CheckBox=skillRow.get_child(0).get_child(0)
			if !skillCheckBox.button_pressed:
				skillCheckBox.disabled=true
				

func on_unchecked():
	skillPoints+=1
	skillPointsContainerValue.text=str(skillPoints)
	if skillPoints>0:
		for skillRow in skillsContainer.get_children():
			var skillCheckBox:CheckBox=skillRow.get_child(0).get_child(0)
			if !skillCheckBox.button_pressed:
				skillCheckBox.disabled=false

func get_selected_skills():
	var selectedSkillArray=[]
	for skillRow in skillsContainer.get_children():
		var skillCheckBox:CheckBox=skillRow.get_child(0).get_child(0)
		if skillCheckBox.button_pressed:
			skillRow.skillItem.Learned=1
			selectedSkillArray.append(skillRow.skillItem)
	return selectedSkillArray
