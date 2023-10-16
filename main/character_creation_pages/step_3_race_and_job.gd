extends Control

@onready var raceOptionButton=$Panel/RaceContainer/RaceOptionButton
@onready var jobOptionButton=$Panel/JobContainer/JobOptionButton
@onready var bonusAttributeOptionButton=$Panel/BonusAttributeContainer/BonuaAttributeOptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in ClientManager.races.values():
		var label=ClientManager.translate_race(i)
		raceOptionButton.add_item(label,i)
	
	for i in ClientManager.jobs.values():
		var label=ClientManager.translate_job(i)
		jobOptionButton.add_item(label,i)
	
	raceOptionButton.selected=-1
	jobOptionButton.selected=-1

func reset():
	raceOptionButton.selected=-1
	jobOptionButton.selected=-1
	bonusAttributeOptionButton.selected=-1
	bonusAttributeOptionButton.hide()

func _on_race_option_button_item_selected(index):
	var summaryPanel:RichTextLabel=$Panel/SummaryContainer/RaceSummary
	var race:Race=ClientManager.get_race_from_index(index)
	if index==ClientManager.races.HUMAN or index==ClientManager.races.HALF_ELF:
		var bonusAttributeContainer=$Panel/BonusAttributeContainer
		bonusAttributeContainer.show()
	else: 
		var bonusAttributeContainer=$Panel/BonusAttributeContainer
		bonusAttributeContainer.hide()
	summaryPanel.clear()
	summaryPanel.append_text(
		"[color=#%s]%s[/color]\n"
		% [Color.BLUE.to_html(false), race.cn_name]
	)
	summaryPanel.append_text(
		"[color=#%s]描述[/color]: %s\n"
		% [Color.BLUE.to_html(false), race.desc]
	)
	var attributes:Dictionary=race.bonus_attributes
	if !attributes.is_empty():
		summaryPanel.append_text(
			"[color=#%s]额外属性[/color]:\n"
			% [Color.BLUE.to_html(false)]
		)
		for key in attributes:
			var value=attributes.get(key)
			if value!=0:
				summaryPanel.append_text(
					"\t[color=#%s]- %s[/color]: %s\n"
					% [Color.SIENNA.to_html(false), ClientManager.translate_attribute_name(key),value]
				)
	if race.bonus_ac>0:
		summaryPanel.append_text(
				"[color=#%s]额外AC[/color]: %s\n"
				% [Color.BLUE.to_html(false), race.bonus_ac]
			)
	if race.bonus_ab>0:
		summaryPanel.append_text(
				"[color=#%s]额外攻击加值[/color]: %s\n"
				% [Color.BLUE.to_html(false), race.bonus_ab]
			)
	if race.bonus_initiative>0:
		summaryPanel.append_text(
				"[color=#%s]额外先攻[/color]: %s\n"
				% [Color.BLUE.to_html(false), race.bonus_initiative]
			)
	if race.bonus_attribute_points>0:
		summaryPanel.append_text(
				"[color=#%s]额外可分配属性点[/color]: %s\n"
				% [Color.BLUE.to_html(false), race.bonus_attribute_points]
			)
	if race.bonus_skill_points>0:
		summaryPanel.append_text(
				"[color=#%s]额外技能点[/color]: %s\n"
				% [Color.BLUE.to_html(false), race.bonus_skill_points]
			)

func _on_job_option_button_item_selected(index):
	var summaryPanel=$Panel/SummaryContainer/JobSummary
	var job:Job=ClientManager.get_job_from_index(index)
	summaryPanel.clear()
	summaryPanel.append_text(
		"[color=#%s]%s[/color]\n"
		% [Color.WEB_MAROON.to_html(false), job.cn_name]
	)
	summaryPanel.append_text(
		"[color=#%s]描述[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.desc]
	)
	summaryPanel.append_text(
		"[color=#%s]生命骰[/color]: D%s\n"
		% [Color.WEB_MAROON.to_html(false), job.hit_dice]
	)
	summaryPanel.append_text(
		"[color=#%s]初始攻击加值[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.l1_bab]
	)
	summaryPanel.append_text(
		"[color=#%s]每级获得攻击加值[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.bab_increment]
	)
	summaryPanel.append_text(
		"[color=#%s]初始魔力值[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.l1_mana]
	)
	summaryPanel.append_text(
		"[color=#%s]每级获得魔力值[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.mana_increment]
	)
	summaryPanel.append_text(
		"[color=#%s]初始技能点数[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.l1_skill_points]
	)
	summaryPanel.append_text(
		"[color=#%s]每级获得技能点数[/color]: %s\n"
		% [Color.WEB_MAROON.to_html(false), job.skill_points_increment]
	)

