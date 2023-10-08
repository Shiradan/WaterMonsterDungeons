local nakama=require("nakama")

local function get_wmd_group_id(_,_)
	local metadata = nil
	local user_id = "23184157-f9df-4586-ad18-da930e747c27"
	local creator_id = nil
	local name = "WMD Public Group"
	local description = "System Group for WMD"
	local lang = "en"
	local open = true
	local avatar_url = nil
	local maxMemberCount = 100

	local createGroup, error = nakama.group_create(user_id, name, creator_id, lang, description, avatar_url, open, metadata, maxMemberCount)
	if error ~= nil then
		-- 处理错误
		return error
	else
		-- 处理成功
		return createGroup
	end
end

nakama.register_rpc(get_wmd_group_id,"get_wmd_group_id")