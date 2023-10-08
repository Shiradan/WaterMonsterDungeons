extends Control

@onready var status_panel=$LoginPanel/StatusPanel

func register_and_login():
	var email=$LoginPanel/UsernameContainer/Username.text
	var password=$LoginPanel/PasswordContainer/Password.text
	
	status_panel.text="认证用户: %s." % email
	var result=await ServerConnection.authenticate_async(email,password)
	
	if result==OK:
		status_panel.text="成功认证用户 %s." % email
	else:
		status_panel.text="认证用户 %s 失败, 请检查邮箱格式并使用八位数以上密码登录." % email
		return

	await connect_to_server()
	await join_system_group()

func connect_to_server():
	var result=await ServerConnection.connect_to_server_async()
	if result==OK:
		status_panel.text="连接到Nakama服务器."
	elif ERR_CANT_CONNECT:
		status_panel.text="连接Nakama服务器失败，请检查网络情况或联系站长."
		return

func join_system_group():
	var result= await ServerConnection.join_wmd_group_async()
	if result==OK:
		status_panel.text="加入水怪地城系统组."
	else:
		status_panel.text="加入水怪地城系统错误，请检查网络情况或联系站长."

func _on_register_login_button_down():
	register_and_login()


func _on_password_text_submitted(_new_text):
	register_and_login()
