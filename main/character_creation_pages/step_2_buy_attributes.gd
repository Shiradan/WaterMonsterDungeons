extends Control

@onready var buyPoints = $Panel/BuyPointsContainer/Value
@onready var strValue = $Panel/AttributesValueContainer/StrContainer/StrValue
@onready var dexValue = $Panel/AttributesValueContainer/DexContainer/DexValue
@onready var conValue = $Panel/AttributesValueContainer/ConContainer/ConValue
@onready var intValue = $Panel/AttributesValueContainer/IntContainer/IntValue
@onready var wisValue = $Panel/AttributesValueContainer/WisContainer/WisValue
@onready var chaValue = $Panel/AttributesValueContainer/ChaContainer/ChaValue

var bp:int

func _ready():
	bp=int(buyPoints.text)

func reset():
	buyPoints.text="20"
	strValue.text="10"
	dexValue.text="10"
	conValue.text="10"
	intValue.text="10"
	wisValue.text="10"
	chaValue.text="10"

func _on_str_add_pressed():
	var strV=int(strValue.text)
	strV=do_buy_points_math_plus(strV)
	buyPoints.text=str(bp)
	strValue.text=str(strV)


func _on_str_minus_pressed():
	var strV=int(strValue.text)
	strV=do_buy_points_math_minus(strV)
	buyPoints.text=str(bp)
	strValue.text=str(strV)


func _on_dex_add_pressed():
	var dex=int(dexValue.text)
	dex=do_buy_points_math_plus(dex)
	buyPoints.text=str(bp)
	dexValue.text=str(dex)


func _on_dex_minus_pressed():
	var dex=int(dexValue.text)
	dex=do_buy_points_math_minus(dex)
	buyPoints.text=str(bp)
	dexValue.text=str(dex)


func _on_con_add_pressed():
	var con=int(conValue.text)
	con=do_buy_points_math_plus(con)
	buyPoints.text=str(bp)
	conValue.text=str(con)


func _on_con_minus_pressed():
	var con=int(conValue.text)
	con=do_buy_points_math_minus(con)
	buyPoints.text=str(bp)
	conValue.text=str(con)


func _on_int_add_pressed():
	var intV=int(intValue.text)
	intV=do_buy_points_math_plus(intV)
	buyPoints.text=str(bp)
	intValue.text=str(intV)


func _on_int_minus_pressed():
	var intV=int(intValue.text)
	intV=do_buy_points_math_minus(intV)
	buyPoints.text=str(bp)
	intValue.text=str(intV)


func _on_wis_add_pressed():
	var wis=int(wisValue.text)
	wis=do_buy_points_math_plus(wis)
	buyPoints.text=str(bp)
	wisValue.text=str(wis)


func _on_wis_minus_pressed():
	var wis=int(wisValue.text)
	wis=do_buy_points_math_minus(wis)
	buyPoints.text=str(bp)
	wisValue.text=str(wis)


func _on_cha_add_pressed():
	var cha=int(chaValue.text)
	cha=do_buy_points_math_plus(cha)
	buyPoints.text=str(bp)
	chaValue.text=str(cha)


func _on_cha_minus_pressed():
	var cha=int(chaValue.text)
	cha=do_buy_points_math_minus(cha)
	buyPoints.text=str(bp)
	chaValue.text=str(cha)


func do_buy_points_math_plus(attr):
	match attr:
		7:
			if bp>=2:
				attr+=1
				bp-=2
		8:
			if bp>=1:
				attr+=1
				bp-=1
		9:
			if bp>=1:
				attr+=1
				bp-=1
		10:
			if bp>=1:
				attr+=1
				bp-=1
		11:
			if bp>=1:
				attr+=1
				bp-=1
		12:
			if bp>=1:
				attr+=1
				bp-=1
		13:
			if bp>=2:
				attr+=1
				bp-=2 
		14:
			if bp>=2:
				attr+=1
				bp-=2
		15:
			if bp>=3:
				attr+=1
				bp-=3
		16:
			if bp>=3:
				attr+=1
				bp-=3
		17:
			if bp>=4:
				attr+=1
				bp-=4
	return attr
		
func do_buy_points_math_minus(attr):
	match attr:
		8:
			attr-=1
			bp+=2
		9:
			attr-=1
			bp+=1
		10:
			attr-=1
			bp+=1
		11:
			attr-=1
			bp+=1
		12:
			attr-=1
			bp+=1
		13:
			attr-=1
			bp+=1
		14:
			attr-=1
			bp+=2
		15:
			attr-=1
			bp+=2
		16:
			attr-=1
			bp+=3
		17:
			attr-=1
			bp+=3
		18:
			attr-=1
			bp+=4
	return attr
