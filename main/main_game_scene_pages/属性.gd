extends Panel

@onready var strValue = $AttributesValueContainer/StrContainer/StrValue
@onready var dexValue = $AttributesValueContainer/DexContainer/DexValue
@onready var conValue = $AttributesValueContainer/ConContainer/ConValue
@onready var intValue = $AttributesValueContainer/IntContainer/IntValue
@onready var wisValue = $AttributesValueContainer/WisContainer/WisValue
@onready var chaValue = $AttributesValueContainer/ChaContainer/ChaValue
@onready var levelupPointsValue = $LevelupPointsContainer/LevelupPointsValue


var left_points:int=0

func _on_str_add_pressed():
	var strV=int(strValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints>0:
		strV+=1
		levelupPoints-=1
	strValue.text=str(strV)
	levelupPointsValue.text=str(levelupPoints)
		

func _on_str_minus_pressed():
	var strV=int(strValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints<left_points:
		strV-=1
		levelupPoints+=1
	strValue.text=str(strV)
	levelupPointsValue.text=str(levelupPoints)


func _on_dex_add_pressed():
	var dex=int(dexValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints>0:
		dex+=1
		levelupPoints-=1
	dexValue.text=str(dex)
	levelupPointsValue.text=str(levelupPoints)


func _on_dex_minus_pressed():
	var dex=int(dexValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints<left_points:
		dex-=1
		levelupPoints+=1
	dexValue.text=str(dex)
	levelupPointsValue.text=str(levelupPoints)


func _on_con_add_pressed():
	var con=int(conValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints>0:
		con+=1
		levelupPoints-=1
	conValue.text=str(con)
	levelupPointsValue.text=str(levelupPoints)


func _on_con_minus_pressed():
	var con=int(conValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints<left_points:
		con-=1
		levelupPoints+=1
	conValue.text=str(con)
	levelupPointsValue.text=str(levelupPoints)


func _on_int_add_pressed():
	var intV=int(intValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints>0:
		intV+=1
		levelupPoints-=1
	intValue.text=str(intV)
	levelupPointsValue.text=str(levelupPoints)


func _on_int_minus_pressed():
	var intV=int(intValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints<left_points:
		intV-=1
		levelupPoints+=1
	intValue.text=str(intV)
	levelupPointsValue.text=str(levelupPoints)


func _on_wis_add_pressed():
	var wis=int(wisValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints>0:
		wis+=1
		levelupPoints-=1
	wisValue.text=str(wis)
	levelupPointsValue.text=str(levelupPoints)


func _on_wis_minus_pressed():
	var wis=int(wisValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints<left_points:
		wis-=1
		levelupPoints+=1
	wisValue.text=str(wis)
	levelupPointsValue.text=str(levelupPoints)


func _on_cha_add_pressed():
	var cha=int(chaValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints>0:
		cha+=1
		levelupPoints-=1
	chaValue.text=str(cha)
	levelupPointsValue.text=str(levelupPoints)


func _on_cha_minus_pressed():
	var cha=int(chaValue.text)
	var levelupPoints=int(levelupPointsValue.text)
	if levelupPoints<left_points:
		cha-=1
		levelupPoints+=1
	chaValue.text=str(cha)
	levelupPointsValue.text=str(levelupPoints)


