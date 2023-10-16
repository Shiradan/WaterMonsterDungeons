local nakama=require("nakama")

local function _get_name_collection()
    local object_ids = {
        {
            collection = "wmd_data",
            key = "names"
        }
    }

    local objects = nakama.storage_read(object_ids)

    local names
    for _, object in pairs(objects) do
        names = object.value
        if names ~= nil then
            break
        end
    end

    if names ~= nil then
        return names
    else
        return {["names"] = {}}
    end
end

local function _write_names(names)
    local new_objects = {
        {
            collection = "wmd_data",
            key = "names",
            value = {["names"] = names},
            permission_read = 2,
            permission_write = 0
        }
    }

    nakama.storage_write(new_objects)
end


local function check_wmd_character_name(_, payload)
    local names = _get_name_collection().names

    local name = payload

    for _, current_name in ipairs(names) do
        if current_name == name then
            return "0"
        end
    end

    return "1"
end

-- Register a name inside non-user-owned storage that contains all names so
-- far, if the name is available.
-- @param payload A string representing the name to register.
-- @return "0" if the name is already taken, "1" if it's been registered successfully.
local function register_wmd_character_name(_, payload)
    local names = _get_name_collection().names

    local name = payload

    for _, current_name in ipairs(names) do
        if current_name == name then
            return "0"
        end
    end

    table.insert(names, name)

    _write_names(names)

    return "1"
end

-- Removes a name from inside non-user-owned storage, freeing it for re-use if it was taken.
-- @param payload A string representing the name to remove.
-- @return "1"
local function remove_wmd_character_name(_, payload)
    local names = _get_name_collection().names

    local name = payload

    local idx
    for k, current_name in ipairs(names) do
        if current_name == name then
            idx = k
            break
        end
    end

    if idx ~= nil then
        table.remove(names, idx)

        _write_names(names)
    end

    return "1"
end

nakama.register_rpc(check_wmd_character_name,"check_wmd_character_name")
nakama.register_rpc(register_wmd_character_name, "register_wmd_character_name")
nakama.register_rpc(remove_wmd_character_name, "remove_wmd_character_name")