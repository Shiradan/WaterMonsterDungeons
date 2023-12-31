extends Control

signal rolled_dice

func _on_roll_pressed():
	emit_signal("rolled_dice")
	var rng = RandomNumberGenerator.new()
	var strV:int=0
	while strV<7:
		strV=dice_syntax.roll('4d6k3',rng).result
	var dex:int=0
	while dex<7:
		dex=dice_syntax.roll('4d6k3',rng).result
	var con:int=0
	while con<7:
		con=dice_syntax.roll('4d6k3',rng).result
	var intV:int=0
	while intV<7:
		intV=dice_syntax.roll('4d6k3',rng).result
	var wis:int=0
	while wis<7:
		wis=dice_syntax.roll('4d6k3',rng).result
	var cha:int=0
	while cha<7:
		cha=dice_syntax.roll('4d6k3',rng).result
		
	var strValue=$Panel/AttributesValueContainer/StrContainer/StrValue
	var dexValue=$Panel/AttributesValueContainer/DexContainer/DexValue
	var conValue=$Panel/AttributesValueContainer/ConContainer/ConValue
	var intValue=$Panel/AttributesValueContainer/IntContainer/IntValue
	var wisValue=$Panel/AttributesValueContainer/WisContainer/WisValue
	var chaValue=$Panel/AttributesValueContainer/ChaContainer/ChaValue
	
	strValue.text=str(strV)
	dexValue.text=str(dex)
	conValue.text=str(con)
	intValue.text=str(intV)
	wisValue.text=str(wis)
	chaValue.text=str(cha)

func reset():
	var strValue=$Panel/AttributesValueContainer/StrContainer/StrValue
	var dexValue=$Panel/AttributesValueContainer/DexContainer/DexValue
	var conValue=$Panel/AttributesValueContainer/ConContainer/ConValue
	var intValue=$Panel/AttributesValueContainer/IntContainer/IntValue
	var wisValue=$Panel/AttributesValueContainer/WisContainer/WisValue
	var chaValue=$Panel/AttributesValueContainer/ChaContainer/ChaValue
	
	strValue.text="10"
	dexValue.text="10"
	conValue.text="10"
	intValue.text="10"
	wisValue.text="10"
	chaValue.text="10"
