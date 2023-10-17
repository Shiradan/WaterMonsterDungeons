extends HBoxContainer

var cname:String="":set=set_cname
var level:int=0:set=set_level
var race:int=0:set=set_race
var job:int=0:set=set_job
var hp:int=0:set=set_hp
var mana:int=0:set=set_mana
var bab:int=0:set=set_bab
var ac:int=0:set=set_ac

func set_cname(value):
	cname=value
	var nameLabel = $Name
	nameLabel.text=value
	
func set_level(value):
	level=value
	var levelLabel = $Level
	levelLabel.text="等级: "+str(value)

func set_race(value):
	race=value
	var raceLabel = $Race
	raceLabel.text="种族: " + ClientManager.translate_race(value)
	
func set_job(value):
	job=value
	var jobLabel=$Job
	jobLabel.text="职业: " + ClientManager.translate_job(value)
	
func set_hp(value):
	hp=value
	var hpLabel=$HP
	hpLabel.text="生命值: " + str(value)

func set_mana(value):
	mana=value
	var manaLabel=$Mana
	manaLabel.text="魔力值: " + str(value)
	
func set_bab(value):
	bab=value
	var babLabel=$BAB
	babLabel.text="BAB: " + str(value)

func set_ac(value):
	ac=value
	var acLabel=$AC
	acLabel.text="AC: " + str(value)
