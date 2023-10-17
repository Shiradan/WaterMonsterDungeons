extends Node2D

@onready var character_name = $GameUI/CharacterName
@onready var general_info = $GameUI/GeneralInfo

func _ready():
	character_name.text=ClientManager.character.character_name
	general_info.text=str(ClientManager.character.level)+"级"+" "+\
		ClientManager.translate_race(ClientManager.character.race)+" "+\
		ClientManager.translate_job(ClientManager.character.job)
	setup_team_members()
		
func setup_team_members():
	var member_list=await ServerConnection.list_group_members()
	for member in member_list.group_users:
		var user_id=member.user.id
		var user_charactersStorageObjectList=await ServerConnection.read_user_characters_async(user_id)
		for object in user_charactersStorageObjectList:
			if int(object.active)==1:
				var member_active_character:Character=ClientManager.to_character(object)
				var members = $"GameUI/TabContainer/队伍/MarginContainer/Members"
				var memberRow:HBoxContainer=load("res://main/main_game_scene_pages/team_member_row.tscn").instantiate()
				memberRow.cname=member_active_character.character_name
				memberRow.level=member_active_character.level
				memberRow.race=member_active_character.race
				memberRow.job=member_active_character.job
				memberRow.hp=member_active_character.max_hp
				memberRow.mana=member_active_character.max_mana
				memberRow.bab=member_active_character.base_attack_bonus
				memberRow.ac=member_active_character.armor_class
				members.add_child(memberRow)




