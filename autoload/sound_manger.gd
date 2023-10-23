extends Node

@onready var ovani_player = $OvaniPlayer
@onready var audio_stream_player = $AudioStreamPlayer
var login_page_bgm:OvaniSong=load("res://music/Wonderful (RT 5.334)/wonderful.tres")
var main_bgm:OvaniSong=load("res://music/Relaxed (RT 6.314)/relaxed.tres")
var mouse_click=load("res://music/Click Glass Dry.wav")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouseEvent = event as InputEventMouseButton
		if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
			audio_stream_player.stream=mouse_click
			audio_stream_player.play()

func play_login_page_bgm():
	ovani_player.PlaySongNow(login_page_bgm)

func play_main_bgm():
	ovani_player.PlaySongNow(main_bgm,10)
