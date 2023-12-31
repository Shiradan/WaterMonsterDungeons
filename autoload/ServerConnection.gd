extends Node

const DEFAULT_PORT=9943
const REMOTE_NAKAMA_SERVER_IP="nk.ccdw.fun"
const SERVER_KEY="chaibao20230808"
const DEFAULT_PROTOCOL="https"

enum ReadPermissions {
	NO_READ,
	OWNER_READ,
	PUBLIC_READ
}

enum WritePermissions {
	NO_WRITE,
	OWNER_WRITE,
	PUBLIC_WRITE
}

enum OpCodes {
	UPDATE_POSITION = 1,
	UPDATE_INPUT = 2,
	UPDATE_STATE = 3,
	#UPDATE_JUMP,
	DO_SPAWN = 5,
	#UPDATE_COLOR,
	INITIAL_STATE = 7
}

# Emitted when the server has received the game state dump for all connected characters
signal initial_state_received(positions, inputs, names)

# Emitted when the `presences` Dictionary has changed by joining or leaving clients
signal presences_changed

# Emitted when the server has sent an updated game state. 10 times per second.
signal state_updated(positions, inputs)

# Emitted when the server has been informed of a new character having been selected and is ready to
# spawn.
signal character_spawned(id, name)

# Emitted when the server has received a new chat message into the world channel
signal chat_message_received(sender_id, message)

var _client=Nakama.create_client(SERVER_KEY,REMOTE_NAKAMA_SERVER_IP,DEFAULT_PORT,DEFAULT_PROTOCOL,10,NakamaLogger.LOG_LEVEL.ERROR)
var _session:NakamaSession
var _socket:NakamaSocket
var _worldId=""
var _presences={}: set=_no_set
var error_message := "": set= _no_set, get= _get_error_message
var _exception_handler := ExceptionHandler.new()
var _channelId: String
var _groupId=""

func authenticate_async(email, password):
	var result=OK
	var new_session = await _client.authenticate_email_async(email,password,null,true)
	if not new_session.is_exception():
		_session=new_session
	else:
		@warning_ignore("int_as_enum_without_cast")
		result=new_session.get_exception().status_code
		print(new_session.get_exception()._to_string())
	return result

func connect_to_server_async():
	_socket=Nakama.create_socket_from(_client)
	var result=await _socket.connect_async(_session)
	if not result.is_exception():
		#warning-ignore: return_value_discarded
		_socket.connect("connected", _on_NakamaSocket_connected)
		#warning-ignore: return_value_discarded
		_socket.connect("closed", _on_NakamaSocket_closed)
		#warning-ignore: return_value_discarded
		_socket.connect("connection_error", _on_NakamaSocket_connection_error)
		#warning-ignore: return_value_discarded
		_socket.connect("received_error", _on_NakamaSocket_received_error)
		#warning-ignore: return_value_discarded
		_socket.connect("received_match_presence", _on_NakamaSocket_received_match_presence)
		#warning-ignore: return_value_discarded
		_socket.connect("received_match_state", _on_NakamaSocket_received_match_state)
		#warning-ignore: return_value_discarded
		_socket.connect("received_channel_message", _on_NamakaSocket_received_channel_message)

		return OK
	return ERR_CANT_CONNECT

func join_wmd_group_async():
	var result=OK
	var userGroupList : NakamaAPI.ApiUserGroupList = await _client.list_user_groups_async(_session, get_user_id())
	if userGroupList.is_exception():
		@warning_ignore("int_as_enum_without_cast")
		result=userGroupList.get_exception().status_code
		print(userGroupList.get_exception()._to_string())
		return result
	else:
		if userGroupList.user_groups.size()>0:
			for ug in userGroupList.user_groups:
				var g = ug.group as NakamaAPI.ApiGroup
				if g.name=="WMD Public Group":
					_groupId=g.id
					print("Group %s role %s" % [g.id, ug.state])
					return result
	
	var list : NakamaAPI.ApiGroupList = await _client.list_groups_async(_session, "WMD Public Group", 20)
	if list.is_exception():
		@warning_ignore("int_as_enum_without_cast")
		result=list.get_exception().status_code
		print(list.get_exception()._to_string())
	else:
		if list.groups.size() == 0:
			var group:NakamaAPI.ApiRpc=await _client.rpc_async(_session,"get_wmd_group_id","")
			if not group.is_exception():
				_groupId=group.payload
				var join : NakamaAsyncResult = await _client.join_group_async(_session, _groupId)
				if join.is_exception():
					@warning_ignore("int_as_enum_without_cast")
					result=join.get_exception().status_code
					print(join.get_exception()._to_string())
				else:
					print("Sent group join request %s" % _groupId)
			else:
				@warning_ignore("int_as_enum_without_cast")
				result=group.get_exception().status_code
				print(group.get_exception()._to_string())
		else:
			for g in list.groups:
				var group = g as NakamaAPI.ApiGroup
				if g.name=="WMD Public Group":
					_groupId=g.id
					print("Group: %s, id %s" % [group.name, group.id])
					break
			var cursor = list.cursor
			while cursor: # While there are more results get next page.
				list = await _client.list_groups_async(_session, "WMD Public Group", 20, cursor)
				if list.is_exception():
					@warning_ignore("int_as_enum_without_cast")
					result=list.get_exception().status_code
					print(list.get_exception()._to_string())
					return result
				for g in list.groups:
					var group = g as NakamaAPI.ApiGroup
					if group.name=="WMD Public Group":
						_groupId=group.id
						print("Group: %s, id %s" % [group.name, group.id])
						break
				cursor = list.cursor
				
			var join : NakamaAsyncResult = await _client.join_group_async(_session, _groupId)
			if join.is_exception():
				@warning_ignore("int_as_enum_without_cast")
				result=join.get_exception().status_code
				print(join.get_exception()._to_string())
			else:
				print("Sent group join request %s" % _groupId)
	return result

func join_world_async():
	var world:NakamaAPI.ApiRpc=await _client.rpc_async(_session,"get_wmd_world_id","")
	if not world.is_exception():
		_worldId=world.payload
		
	var matchJoinResult:NakamaRTAPI.Match=await _socket.join_match_async(_worldId)
	if matchJoinResult.is_exception():
		var exception:NakamaException=matchJoinResult.get_exception()
		printerr("Error joining the match: %s - %s" % [exception.status_code,exception.message])
		return {}
	
	for presence in matchJoinResult.presences:
		_presences[presence.user_id]=presence
	
	var roomname = "WMD"
	var persistence = true
	var hidden = false
	var type = NakamaSocket.ChannelType.Room
	var channel : NakamaRTAPI.Channel = await _socket.join_chat_async(roomname, type, persistence, hidden)
	if channel.is_exception():
		print("An error occurred: %s" % channel)
		return
	_channelId=channel.id
	print("Now connected to channel id: '%s'" % _channelId)
	
	return _presences

func write_characters_async(chars):
	await _client.write_storage_objects_async(
		_session,
		[
			NakamaWriteStorageObject.new(
				"wmd_data",
				"characters",
				ReadPermissions.PUBLIC_READ,
				WritePermissions.OWNER_WRITE,
				JSON.stringify(
					{
						characters=chars
					}
				),
				""
			)
		]
	)

func write_skills_learned_async(sks):
	await _client.write_storage_objects_async(
		_session,
		[
			NakamaWriteStorageObject.new(
				"wmd_data",
				"skills",
				ReadPermissions.PUBLIC_READ,
				WritePermissions.OWNER_WRITE,
				JSON.stringify(
					{
						skills=sks
					}
				),
				""
			)
		]
	)

func write_tactics_async(tactics):
	await _client.write_storage_objects_async(
		_session,
		[
			NakamaWriteStorageObject.new(
				"wmd_data",
				"tactics",
				ReadPermissions.PUBLIC_READ,
				WritePermissions.OWNER_WRITE,
				JSON.stringify(
					{
						tactics=tactics
					}
				),
				""
			)
		]
	)

func read_characters_async():
	var characters=[]
	var storageObjects:NakamaAPI.ApiStorageObjects=await _client.read_storage_objects_async(
		_session,
		[
			NakamaStorageObjectId.new(
				"wmd_data",
				"characters",
				_session.user_id
			)
		]
	)
	
	var parsed_result := _exception_handler.parse_exception(storageObjects)
	if parsed_result != OK:
		return storageObjects.get_exception()._to_string()
	
	if storageObjects.objects.size()>0:
		#get array of dictionary
		var decodedCharacters=JSON.parse_string(storageObjects.objects[0].value).characters
		characters=decodedCharacters
		
	return characters

func read_user_characters_async(user_id):
	var characters=[]
	var storageObjects:NakamaAPI.ApiStorageObjects=await _client.read_storage_objects_async(
		_session,
		[
			NakamaStorageObjectId.new(
				"wmd_data",
				"characters",
				user_id
			)
		]
	)
	
	var parsed_result := _exception_handler.parse_exception(storageObjects)
	if parsed_result != OK:
		return storageObjects.get_exception()._to_string()
	
	if storageObjects.objects.size()>0:
		#get array of dictionary
		var decodedCharacters=JSON.parse_string(storageObjects.objects[0].value).characters
		characters=decodedCharacters
		
	return characters

func read_skills_learned_async():
	var skills=[]
	var storageObjects:NakamaAPI.ApiStorageObjects=await _client.read_storage_objects_async(
		_session,
		[
			NakamaStorageObjectId.new(
				"wmd_data",
				"skills",
				_session.user_id
			)
		]
	)
	var parsed_result := _exception_handler.parse_exception(storageObjects)
	if parsed_result != OK:
		return storageObjects.get_exception()._to_string()
		
	if storageObjects.objects.size()>0:
		#get array of dictionary
		var decodedSkills=JSON.parse_string(storageObjects.objects[0].value).skills
		skills=decodedSkills
		
	return skills

func read_tactics_async():
	var tactics=[]
	var storageObjects:NakamaAPI.ApiStorageObjects=await _client.read_storage_objects_async(
		_session,
		[
			NakamaStorageObjectId.new(
				"wmd_data",
				"tactics",
				_session.user_id
			)
		]
	)
	var parsed_result := _exception_handler.parse_exception(storageObjects)
	if parsed_result != OK:
		return storageObjects.get_exception()._to_string()
		
	if storageObjects.objects.size()>0:
		#get array of dictionary
		var decodedTactics=JSON.parse_string(storageObjects.objects[0].value).tactics
		tactics=decodedTactics
		
	return tactics

func get_user_id() -> String:
	if _session:
		return _session.user_id
	return ""

func send_position_update(position: Vector2):
	if _socket:
		var payload = {
				id = get_user_id(), 
				pos = {
					x = position.x, 
					y = position.y
				}
			}
		_socket.send_match_state_async(_worldId, OpCodes.UPDATE_POSITION, JSON.stringify(payload))

func send_direction_update(input):
	if _socket:
		var payload := {
				id = get_user_id(), 
				inp = {
					dirx=input.x,
					diry=input.y
				}
			}
		_socket.send_match_state_async(_worldId, OpCodes.UPDATE_INPUT, JSON.stringify(payload))

func send_spawn(n: String) -> void:
	if _socket:
		var payload := {id = get_user_id(), nm = n}
		_socket.send_match_state_async(_worldId, OpCodes.DO_SPAWN, JSON.stringify(payload))

func send_text_async(text: String) -> int:
	if not _socket:
		return ERR_UNAVAILABLE

	var data := {"msg": text}

	var message_response: NakamaRTAPI.ChannelMessageAck = await _socket.write_chat_message_async(_channelId, data)

	var parsed_result := _exception_handler.parse_exception(message_response)
	if parsed_result != OK:
		emit_signal(
			"chat_message_received", "SYSTEM", "Error code %s: %s" % [parsed_result, error_message]
		)

	return parsed_result

# Called when the socket was connected.
func _on_NakamaSocket_connected() -> void:
	return

# Called when the socket was closed.
func _on_NakamaSocket_closed():
	_socket.close()
 
# Called when the socket was unable to connect.
func _on_NakamaSocket_connection_error(error: int) -> void:
	error_message = "Unable to connect with code %s" % error
	_socket.close()

# Called when the socket reported an error.
func _on_NakamaSocket_received_error(error: NakamaRTAPI.Error) -> void:
	error_message = str(error)
	_socket = null

# Called when the server reported presences have changed.
func _on_NakamaSocket_received_match_presence(new_presences: NakamaRTAPI.MatchPresenceEvent) -> void:
	for leave in new_presences.leaves:
		#warning-ignore: return_value_discarded
		_presences.erase(leave.user_id)

	for join in new_presences.joins:
		if not join.user_id == get_user_id():
			_presences[join.user_id] = join

	emit_signal("presences_changed")

# Called when the server received a custom message from the server.
func _on_NakamaSocket_received_match_state(match_state: NakamaRTAPI.MatchData) -> void:
	var code := match_state.op_code
	var raw := match_state.data

	match code:
		OpCodes.UPDATE_STATE:
			var decoded: Dictionary = JSON.parse_string(raw)

			var positions: Dictionary = decoded.pos
			var inputs: Dictionary = decoded.inp

			emit_signal("state_updated", positions, inputs)

		OpCodes.INITIAL_STATE:
			var decoded: Dictionary = JSON.parse_string(raw)

			var positions: Dictionary = decoded.pos
			var inputs: Dictionary = decoded.inp
			var names: Dictionary = decoded.nms

			emit_signal("initial_state_received", positions, inputs, names)

		OpCodes.DO_SPAWN:
			var decoded: Dictionary = JSON.parse_string(raw)

			var id: String = decoded.id
			var n: String = decoded.nm

			emit_signal("character_spawned", id, n)

# Called when the server received a new chat message.
func _on_NamakaSocket_received_channel_message(message: NakamaAPI.ApiChannelMessage) -> void:
	if message.code != 0:
		return
	var content: Dictionary = JSON.parse_string(message.content)
	emit_signal("chat_message_received", message.sender_id, content.msg)

func _no_set(_value) -> void:
	pass

func _get_error_message() -> String:
	return _exception_handler.error_message

func check_name_availability(cname:String):
	var availability_response: NakamaAPI.ApiRpc = await _client.rpc_async(_session, "check_wmd_character_name", cname)
	var parsed_result := _exception_handler.parse_exception(availability_response)
	if parsed_result != OK:
		return parsed_result
	if availability_response.payload=="1":
		return true
	else:
		return false
	
func register_name_storage(cname:String):
	var availability_response: NakamaAPI.ApiRpc = await _client.rpc_async(_session, "register_wmd_character_name", cname)
	var parsed_result := _exception_handler.parse_exception(availability_response)
	if parsed_result != OK:
		return parsed_result
	if availability_response.payload=="1":
		return true
	else:
		return false

func remove_name_storage(cname:String):
	var availability_response: NakamaAPI.ApiRpc = await _client.rpc_async(_session, "remove_wmd_character_name", cname)
	var parsed_result := _exception_handler.parse_exception(availability_response)
	if parsed_result != OK:
		return parsed_result
	if availability_response.payload=="1":
		return true
	else:
		return false

func list_group_members():
	var member_list : NakamaAPI.ApiGroupUserList = await _client.list_group_users_async(_session, _groupId)

	if member_list.is_exception():
		print("An error occurred: %s" % member_list)
		return
	else:
		return member_list
