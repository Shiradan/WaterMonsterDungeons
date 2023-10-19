extends Control

@onready var progress_bar = $ProgressBar

var text_array=[
	"水怪滋滋滋",
	"水怪噗噗噗",
	"水怪略略略"
]

func _ready():
	var random=randi_range(0,text_array.size()-1)
	$Label.text=text_array[random]

var increaseSpeed = 77
var currentValue = 0

func _process(delta):
	# 根据增加速度更新value值
	currentValue += increaseSpeed * delta
	# 确保value值不超过最大值
	currentValue = min(currentValue, progress_bar.max_value)
	# 更新ProgressBar的value值
	progress_bar.value=currentValue
	if currentValue==progress_bar.max_value:
		get_tree().change_scene_to_file("res://main/main_game_scene.tscn")
