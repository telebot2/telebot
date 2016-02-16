do

-- Check Member
local function check_member_autorealm(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Realm',
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'بله',
          lock_photo = 'خیر',
          lock_member = 'خیر',
          flood = 'بله'
        }
      }
      save_data(_config.moderation.data, data)
      local realms = 'realms'
      if not data[tostring(realms)] then
        data[tostring(realms)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(realms)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'Welcome to your new realm !')
    end
  end
end
local function check_member_realm_add(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Realm',
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'بله',
          lock_photo = 'خیر',
          lock_member = 'خیر',
          flood = 'بله'
        }
      }
      save_data(_config.moderation.data, data)
      local realms = 'realms'
      if not data[tostring(realms)] then
        data[tostring(realms)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(realms)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'Realm has been added!')
    end
  end
end
function check_member_group(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Group',
        moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'بله',
          lock_photo = 'خیر',
          lock_member = 'خیر',
          flood = 'بله',
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'You have been promoted as the owner.')
    end
  end
end
local function check_member_modadd(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Group',
        moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'بله',
          lock_photo = 'خیر',
          lock_member = 'خیر',
          flood = 'بله',
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'Group is added and you have been promoted as the owner ')
    end
  end
end
local function automodadd(msg)
  local data = load_data(_config.moderation.data)
  if msg.action.type == 'chat_created' then
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_group,{receiver=receiver, data=data, msg = msg})
  end
end
local function autorealmadd(msg)
  local data = load_data(_config.moderation.data)
  if msg.action.type == 'chat_created' then
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_autorealm,{receiver=receiver, data=data, msg = msg})
  end
end
local function check_member_realmrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Realm configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local realms = 'realms'
      if not data[tostring(realms)] then
        data[tostring(realms)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(realms)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'Realm has been removed!')
    end
  end
end
local function check_member_modrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'Group has been removed')
    end
  end
end
--End Check Member
local function show_group_settingsmod(msg, data, target)
        if not is_momod(msg) then
        return "فقط مدیر ها میتوانند!"
        end
        local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
                NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])
                print('custom'..NUM_MSG_MAX)
        else
                NUM_MSG_MAX = 0
        end
    end

    local bots_protection = "بله"
    if data[tostring(msg.to.id)]['settings']['lock_bots'] then
        bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
        end

  local lock_link = "خیر"
    if data[tostring(msg.to.id)]['settings']['lock_link'] then
        lock_link = data[tostring(msg.to.id)]['settings']['lock_link']
        end

  local lock_adds= "خیر"
    if data[tostring(msg.to.id)]['settings']['lock_adds'] then
        lock_adds = data[tostring(msg.to.id)]['settings']['lock_adds']
        end

          local lock_eng = "خیر"
    if data[tostring(msg.to.id)]['settings']['lock_eng'] then
        lock_eng = data[tostring(msg.to.id)]['settings']['lock_eng']
        end

          local lock_badw = "خیر"
    if data[tostring(msg.to.id)]['settings']['lock_badw'] then
        lock_badw = data[tostring(msg.to.id)]['settings']['lock_badw']
        end

        local lock_tag = "خیر"
    if data[tostring(msg.to.id)]['settings']['lock_tag'] then
        lock_tag = data[tostring(msg.to.id)]['settings']['lock_tag']
        end

  local lock_leave = "خیر"
    if data[tostring(msg.to.id)]['settings']['lock_leave'] then
        lock_leave = data[tostring(msg.to.id)]['settings']['lock_leave']
        end
local lock_sticker = "خیر"
    if data[tostring(msg.to.id)]['settings']['sticker'] then
        lock_tag = data[tostring(msg.to.id)]['settings']['sticker']
        end
         local settings = data[tostring(target)]['settings']
  local text = "تنظیمات گروه:\nقفله اسم : "..settings.lock_name.."\nقفله عکس : "..settings.lock_photo.."\nقفله تگ : "..lock_tag.."\nقفله اضافه شدن ممبر  : "..settings.lock_member.."\nقفله انگلیسی صحبت کردن 🗣 : "..lock_eng.."\nقفله بازگشت کاربر : "..lock_leave.."\nقفله کلمات رکیک : "..lock_badw.."\nقفله لینک : "..lock_link.."\nقفله تبلیغات : "..lock_adds.."\nقفله استیکر : "..lock_sticker.."\nقفله میزان اسپم : "..NUM_MSG_MAX.."\nقفله ورود ربات : "..bots_protection--"\nPublic: "..public
  return text
end


local function set_descriptionmod(msg, data, target, about)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local data_cat = 'description'
  data[tostring(target)][data_cat] = about
  save_data(_config.moderation.data, data)
  return 'Set group description to:\n'..about
end
local function get_description(msg, data)
  local data_cat = 'description'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'ذخیره نشده است.'
  end
  local about = data[tostring(msg.to.id)][data_cat]
  local about = string.gsub(msg.to.print_name, "_", " ")..':\n\n'..about
  return 'درباره '..about
end
local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'بله' then
    return 'عربی ممنوع است'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'عربی ممنوع است'
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'خیر' then
    return 'عربی مجاز است'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'عربی مجاز است'
  end
end

local function lock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'بله' then
    return 'لینک بسته است!'
  else
    data[tostring(target)]['settings']['lock_link'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'لینک بسته است!'
  end
end
local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return "فط مدیر ها میتوانند!"
  end
  local group_sticker_lock = data[tostring(target)]['settings']['sticker']
  if group_sticker_lock == 'kick' then
    return 'استیکر ممنوع است!'
  else
    data[tostring(target)]['settings']['sticker'] = 'kick'
    save_data(_config.moderation.data, data)
    return 'استیکر ممنوع است!'
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_sticker_lock = data[tostring(target)]['settings']['sticker']
  if group_sticker_lock == 'باشه' then
    return 'استیکر مجاز است!'
  else
    data[tostring(target)]['settings']['sticker'] = 'باشه'
    save_data(_config.moderation.data, data)
    return 'استیکر مجاز است!'
  end
end

local function unlock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'خیر' then
    return 'لینک باز است!'
  else
    data[tostring(target)]['settings']['lock_link'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'لینک باز است!'
  end
end
local function lock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'بله' then
    return 'لینک بسته است!'
  else
    data[tostring(target)]['settings']['lock_link'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'لینک بسته است!'
  end
end

local function unlock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'خیر' then
    return 'لینک باز است!'
  else
    data[tostring(target)]['settings']['lock_link'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'لینک باز است!'
  end
end

local function lock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'بله' then
    return 'اینگلیسی حرف زدن ممنوع است!'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'اینگلیسی حرف زدن ممنوع است!'
  end
end

local function unlock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط ادمین ها میتوانند!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'no' then
    return 'اینگلیسی حرف زدن مجاز است!'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'اینگلیسی حرف زدن مجاز است!'
  end
end
local function lock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'بله' then
    return 'اینگلیسی حرف زدن ممنوع است!'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'اینگلیسی حرف زدن ممنوع است!'
  end
end
local function unlock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'خیر' 
  return 'اینگلیسی حرف زدن مجاز است!'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'اینگلیسی حرف زدن مجاز است!'
  end
end
    
local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'بله' then
    return 'استفاده از # ممنوع است!'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'استفاده از # ممنوع است!'
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'خیر' then
    return 'استفاده از # مجاز است!'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'استفاده از # مجاز است!'
  end
end
local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'بله' then
    return 'استفاده از # ممنوع است!'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'استفاده از # ممنوع است!'  
    end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'خیر' then
    return 'استفاده از # مجاز نیست!'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'استفاده از # مجاز نیست!'
  end
end

local function lock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'بله' then
    return 'کلمات رکیک ممنوع است!'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'کلمات رکیک ممنوع است!'
  end
end

local function unlock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'خیر' then
    return 'کلمات رکیک مجاز است!'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'کلمات رکیک مجاز است!'
  end
end
local function lock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'بله' then
    return 'کلمات رکیک ممنوع است!'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'کلمات رکیک ممنوع است!'
  end
end

local function unlock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'خیر' then
    return 'کلمات رکیک مجاز است!'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'کلمات رکیک مجاز است!'
  end
end

local function lock_group_adds(msg, data, target)
  if not is_momod(msg) then
    return 'فقط مدیر ها میتوانند'!"
  end
  local adds_ban = data[tostring(msg.to.id)]['settings']['adds_ban']
  if adds_ban == 'بله' then
    return 'ورود با لینک قفل است!'
  else
    data[tostring(msg.to.id)]['settings']['adds_ban'] = 'بله'
    save_data(_config.moderation.data, data)
  end
  return 'ورود با لینک قفل است!'
end

local function unlock_group_adds(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local adds_ban = data[tostring(msg.to.id)]['settings']['adds_ban']
  if adds_ban == 'خیر' then
    return 'ورود با لینک باز است!'
  else
    data[tostring(msg.to.id)]['settings']['adds_ban'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'ورود با لینک باز است!'
  end
end


local function lock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
  if leave_ban == 'بله' then
    return 'فردی که لفت میدهد بن میشود'
  else
    data[tostring(msg.to.id)]['settings']['leave_ban'] = 'بله'
    save_data(_config.moderation.data, data)
  end
  return 'فردی که لفت میدهد بن میشود'
end

local function unlock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
  if leave_ban == 'خیر' then
    return 'فردی که لفت میدهد بن نمیشود'
  else
    data[tostring(msg.to.id)]['settings']['leave_ban'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'فردی که لفت میدهد بن نمیشود'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'بله' then
    return 'ورود ربات ماز نیست'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'ورود ربات ماز نیست'
  end
end
local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'خیر' then
    return 'ورود ربات مجاز است'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'ورود ربات مجاز است'
  end
end

local function lock_group_namemod(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == 'بله' then
    return 'نام گروه قفل است'
  else
    data[tostring(target)]['settings']['lock_name'] = 'بله'
    save_data(_config.moderation.data, data)
    rename_chat('chat#id'..target, group_name_set, ok_cb, false)
    return 'نام گروه قفل است'
  end
end
local function unlock_group_namemod(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == 'خیر' then
    return 'قفله نام گروه باز است'
  else
    data[tostring(target)]['settings']['lock_name'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'قفله نام گروه باز است'
  end
end
local function lock_group_floodmod(msg, data, target)
  if not is_owner(msg) then
    return "فقط مدیر میتواند"
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'بله' then
    return 'میزان اسپم قفل است'
  else
    data[tostring(target)]['settings']['flood'] = 'بله'
    save_data(_config.moderation.data, data)
    return 'میزان اسپم قفل است'
  end
end

local function unlock_group_floodmod(msg, data, target)
  if not is_owner(msg) then
    return "فقط ادمین میتواند"
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return 'میزان اسپم آزاد است'
  else
    data[tostring(target)]['settings']['flood'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'میزان اسپم آزاد است'
  end
end

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'بله' then
    return 'قفله اضافه شدن ممبر بسته است'
  else
    data[tostring(target)]['settings']['lock_member'] = 'بله'
    save_data(_config.moderation.data, data)
  end
  return 'قفله اضافه شدن ممبر بسته است'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'خیر' then
    return 'قفله اضافه شدن ممبر بسته نیست'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return 'قفله اضافه شدن ممبر باز است'
  end
end

local function unlock_group_photomod(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیر ها میتوانند!"
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'خیر' then
    return 'قفله عکس گروه بسته نیست'
  else
data[tostring(target)]['settings']['lock_photo'] = 'خیر'
    save_data(_config.moderation.data, data)
    return 'قفله عکس گروه باز است'
  end
end

local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return "فقط مدیران گروه میتوانند!"
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'قوانین گروه هست:\n'..rules
end
local function modadd(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین ربات نیستید"
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    return 'Group is already added.'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modadd,{receiver=receiver, data=data, msg = msg})
end
local function modadd(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین ربات نیستید"
  end
  local data = load_data(_config.moderation.data)
  if is_group(msg) then
    return 'Group is already added.'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modadd,{receiver=receiver, data=data, msg = msg})
end
local function realmadd(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین ربات نیستید"
  end
  local data = load_data(_config.moderation.data)
  if is_realm(msg) then
    return 'Realm is already added.'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realm_add,{receiver=receiver, data=data, msg = msg}) 
end
-- Global functions
function modrem(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین ربات نیستید"
  end
  local data = load_data(_config.moderation.data)
  if not is_group(msg) then
    return 'Group is not added.'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modrem,{receiver=receiver, data=data, msg = msg})
end

function realmrem(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین ربات نیستید"
  end
  local data = load_data(_config.moderation.data)
  if not is_realm(msg) then
    return 'Realm is not added.'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realmrem,{receiver=receiver, data=data, msg = msg})
end
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'گروه قانونی ندارد.'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local rules = 'قوانین گروه:\n'..rules
  return rules
end

local function set_group_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/chat_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    chat_set_photo (receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    data[tostring(msg.to.id)]['settings']['lock_photo'] = 'بله'
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

local function promote(receiver, member_username, member_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'chat#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if data[group]['moderators'][tostring(member_id)] then
    return send_large_msg(receiver, member_username..' کاربر میدر بوده است.')
  end
  data[group]['moderators'][tostring(member_id)] = member_username
  save_data(_config.moderation.data, data)
  return send_large_msg(receiver, member_username..' به مدیران اضافه شد.')
end

local function promote_by_reply(extra, success, result)
    local msg = result
    local full_name = (msg.from.first_name or '')..' '..(msg.from.last_name or '')
    if msg.from.username then
      member_username = '@'.. msg.from.username
    else
      member_username = full_name
    end
    local member_id = msg.from.id
    if msg.to.type == 'chat' then
      return promote(get_receiver(msg), member_username, member_id)
    end  
end

local function demote(receiver, member_username, member_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'chat#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if not data[group]['moderators'][tostring(member_id)] then
    return send_large_msg(receiver, member_username..' گروه مدیری ندارد.')
  end
  data[group]['moderators'][tostring(member_id)] = nil
  save_data(_config.moderation.data, data)
  return send_large_msg(receiver, member_username..' از مدیری برکنار شد.')
end

local function demote_by_reply(extra, success, result)
    local msg = result
    local full_name = (msg.from.first_name or '')..' '..(msg.from.last_name or '')
    if msg.from.username then
      member_username = '@'..msg.from.username
    else
      member_username = full_name
    end
    local member_id = msg.from.id
    if msg.to.type == 'chat' then
      return demote(get_receiver(msg), member_username, member_id)
    end  
end

local function setowner_by_reply(extra, success, result)
  local msg = result
  local receiver = get_receiver(msg)
  local data = load_data(_config.moderation.data)
  local name_log = msg.from.print_name:gsub("_", " ")
  data[tostring(msg.to.id)]['set_owner'] = tostring(msg.from.id)
      save_data(_config.moderation.data, data)
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] setted ["..msg.from.id.."] as owner")
      local text = msg.from.print_name:gsub("_", " ").." ادمین جدید اصلی گپ هست"
      return send_large_msg(receiver, text)
end

local function promote_demote_res(extra, success, result)
--vardump(result)
--vardump(extra)
      local member_id = result.id
      local member_username = "@"..result.username
      local chat_id = extra.chat_id
      local mod_cmd = extra.mod_cmd
      local receiver = "chat#id"..chat_id
      if mod_cmd == 'promote' then
        return promote(receiver, member_username, member_id)
      elseif mod_cmd == 'demote' then
        return demote(receiver, member_username, member_id)
      end
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'Group is not added.'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then --fix way
    return 'گروه مدیری ندارد.'
  end
  local i = 1
  local message = '\nلیست مدیر های گروه ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

local function callbackres(extra, success, result)
--vardump(result)
  local user = result.id
  local name = string.gsub(result.print_name, "_", " ")
  local chat = 'chat#id'..extra.chatid
  send_large_msg(chat, user..'\n'..name)
  return user
end


local function help()
  local help_text = tostring(_config.help_text)
  return help_text
end

local function cleanmember(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user(v.id, result.id)     
  end
end

local function killchat(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.id, result.id)     
  end
end

local function killrealm(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.id, result.id)     
  end
end

local function user_msgs(user_id, chat_id)
  local user_info
  local uhash = 'user:'..user_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..user_id..':'..chat_id
  user_info = tonumber(redis:get(um_hash) or 0)
  return user_info
end

local function kick_zero(cb_extra, success, result)
    local chat_id = cb_extra.chat_id
    local chat = "chat#id"..chat_id
    local ci_user
    local re_user
    for k,v in pairs(result.members) do
        local si = false
        ci_user = v.id
        local hash = 'chat:'..chat_id..':users'
        local users = redis:smembers(hash)
        for i = 1, #users do
            re_user = users[i]
            if tonumber(ci_user) == tonumber(re_user) then
                si = true
            end
        end
        if not si then
            if ci_user ~= our_id then
                if not is_momod2(ci_user, chat_id) then
                  chat_del_user(chat, 'user#id'..ci_user, ok_cb, true)
                end
            end
        end
    end
end

local function kick_inactive(chat_id, num, receiver)
    local hash = 'chat:'..chat_id..':users'
    local users = redis:smembers(hash)
    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = user_msgs(user_id, chat_id)
        local nmsg = user_info
        if tonumber(nmsg) < tonumber(num) then
            if not is_momod2(user_id, chat_id) then
              chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, true)
            end
        end
    end
    return chat_info(receiver, kick_zero, {chat_id = chat_id})
end

local function run(msg, matches)
  local data = load_data(_config.moderation.data)
  local receiver = get_receiver(msg)
   local name_log = user_print_name(msg.from)
  local group = msg.to.id
  if msg.media then
    if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_chat_msg(msg) and is_momod(msg) then
      load_photo(msg.id, set_group_photo, msg)
    end
  end
  if matches[1] == 'add' and not matches[2] then
    if is_realm(msg) then
       return 'Error: Already a realm.'
    end
    print("group "..msg.to.print_name.."("..msg.to.id..") added")
    return modadd(msg)
  end
   if matches[1] == 'add' and matches[2] == 'realm' then
    if is_group(msg) then
       return 'ربات فعال است.'
    end
    print("group "..msg.to.print_name.."("..msg.to.id..") added as a realm")
    return realmadd(msg)
  end
  if matches[1] == 'rem' and not matches[2] then
    print("group "..msg.to.print_name.."("..msg.to.id..") removed")
    return modrem(msg)
  end
  if matches[1] == 'rem' and matches[2] == 'realm' then
    print("group "..msg.to.print_name.."("..msg.to.id..") removed as a realm")
    return realmrem(msg)
  end
  if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "group" then
    return automodadd(msg)
  end
  if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "realm" then
    return autorealmadd(msg)
  end

  if msg.to.id and data[tostring(msg.to.id)] then
    local settings = data[tostring(msg.to.id)]['settings']
    if matches[1] == 'chat_add_user' then
      if not msg.service then
        return "Are you trying to troll me?"
      end
      local group_member_lock = settings.lock_member
      local user = 'user#id'..msg.action.user.id
      local chat = 'chat#id'..msg.to.id
      if group_member_lock == 'yes' and not is_owner2(msg.action.user.id, msg.to.id) then
        chat_del_user(chat, user, ok_cb, true)
      elseif group_member_lock == 'yes' and tonumber(msg.from.id) == tonumber(our_id) then
        return nil
      elseif group_member_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'chat_del_user' then
      if not msg.service then
         -- return "Are you trying to troll me?"
      end
      local user = 'user#id'..msg.action.user.id
      local chat = 'chat#id'..msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted user  "..user)
    end
    if matches[1] == 'chat_delete_photo' then
      if not msg.service then
        return "Are you trying to troll me?"
      end
      local group_photo_lock = settings.lock_photo
      if group_photo_lock == 'yes' then
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        redis:incr(picturehash)
        ---
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        local picprotectionredis = redis:get(picturehash) 
        if picprotectionredis then 
          if tonumber(picprotectionredis) == 4 and not is_owner(msg) then 
            kick_user(msg.from.id, msg.to.id)
          end
          if tonumber(picprotectionredis) ==  8 and not is_owner(msg) then 
            ban_user(msg.from.id, msg.to.id)
            local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
            redis:set(picturehash, 0)
          end
        end
        
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] tried to deleted picture but failed  ")
        chat_set_photo(receiver, settings.set_photo, ok_cb, false)
      elseif group_photo_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'chat_change_photo' and msg.from.id ~= 0 then
      if not msg.service then
        return "Are you trying to troll me?"
      end
      local group_photo_lock = settings.lock_photo
      if group_photo_lock == 'yes' then
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        redis:incr(picturehash)
        ---
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        local picprotectionredis = redis:get(picturehash) 
        if picprotectionredis then 
          if tonumber(picprotectionredis) == 4 and not is_owner(msg) then 
            kick_user(msg.from.id, msg.to.id)
          end
          if tonumber(picprotectionredis) ==  8 and not is_owner(msg) then 
            ban_user(msg.from.id, msg.to.id)
          local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
          redis:set(picturehash, 0)
          end
        end
        
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] tried to change picture but failed  ")
        chat_set_photo(receiver, settings.set_photo, ok_cb, false)
      elseif group_photo_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'chat_rename' then
      if not msg.service then
        return "Are you trying to troll me?"
      end
      local group_name_set = settings.set_name
      local group_name_lock = settings.lock_name
      local to_rename = 'chat#id'..msg.to.id
      if group_name_lock == 'yes' then
        if group_name_set ~= tostring(msg.to.print_name) then
          local namehash = 'name:changed:'..msg.to.id..':'..msg.from.id
          redis:incr(namehash)
          local namehash = 'name:changed:'..msg.to.id..':'..msg.from.id
          local nameprotectionredis = redis:get(namehash) 
          if nameprotectionredis then 
            if tonumber(nameprotectionredis) == 4 and not is_owner(msg) then 
              kick_user(msg.from.id, msg.to.id)
            end
            if tonumber(nameprotectionredis) ==  8 and not is_owner(msg) then 
              ban_user(msg.from.id, msg.to.id)
              local namehash = 'name:changed:'..msg.to.id..':'..msg.from.id
              redis:set(namehash, 0)
            end
          end
          
          savelog(msg.to.id, name_log.." ["..msg.from.id.."] tried to change name but failed  ")
          rename_chat(to_rename, group_name_set, ok_cb, false)
        end
      elseif group_name_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'setname' and is_momod(msg) then
      local new_name = string.gsub(matches[2], '_', ' ')
      data[tostring(msg.to.id)]['settings']['set_name'] = new_name
      save_data(_config.moderation.data, data)
      local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
      local to_rename = 'chat#id'..msg.to.id
      rename_chat(to_rename, group_name_set, ok_cb, false)
      
      savelog(msg.to.id, "گروه { "..msg.to.print_name.." }  تغییر داده شد به [ "..new_name.." ]  "..name_log.." ["..msg.from.id.."]")
    end
    if matches[1] == 'setphoto' and is_momod(msg) then
      data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
      save_data(_config.moderation.data, data)
      return 'لطفا عکسی که میخواهید برای گروه تایین کنید را ارسال  کنید'
    end
    if matches[1] == 'promote' and not matches[2] then
      if not is_owner(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, promote_by_reply, false)
      end
    end
    if matches[1] == 'promote' and matches[2] then
      if not is_momod(msg) then
        return
      end
      if not is_owner(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد"
      end
	local member = matches[2]
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @".. member)
	local cbres_extra = {
	chat_id = msg.to.id,
        mod_cmd = 'promote', 
	from_id = msg.from.id
	}
	local username = matches[2]
	local username = string.gsub(matches[2], '@', '')
	return res_user(username, promote_demote_res, cbres_extra)
    end
    if matches[1] == 'demote' and not matches[2] then
      if not is_owner(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, demote_by_reply, false)
      end
    end
    if matches[1] == 'demote' and matches[2] then
      if not is_momod(msg) then
        return
      end
      if not is_owner(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد"
      end
      if string.gsub(matches[2], "@", "") == msg.from.username and not is_owner(msg) then
        return "شما قادر به انجام این کار نیستید"
      end
	local member = matches[2]
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @".. member)
	local cbres_extra = {
	chat_id = msg.to.id,
        mod_cmd = 'demote', 
	from_id = msg.from.id
	}
	local username = matches[2]
	local username = string.gsub(matches[2], '@', '')
	return res_user(username, promote_demote_res, cbres_extra)
    end
    if matches[1] == 'modlist' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] ادمین های گپ")
      return modlist(msg)
    end
    if matches[1] == 'about' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] درباره")
      return get_description(msg, data)
    end
    if matches[1] == 'rules' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] قوانین")
      return get_rules(msg, data)
    end
    if matches[1] == 'set' then
      if matches[2] == 'rules' then
        rules = matches[3]
        local target = msg.to.id
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] قوانین تغییر کرد به ["..matches[3].."]")
        return set_rulesmod(msg, data, target)
      end
      if matches[2] == 'about' then
        local data = load_data(_config.moderation.data)
        local target = msg.to.id
        local about = matches[3]
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] درباره ی گروه تغییر کرد به ["..matches[3].."]")
        return set_descriptionmod(msg, data, target, about)
      end
    end
   if matches[1] == 'lock' or matches[1] == 'l' then
      local target = msg.to.id
      if matches[2] == 'sticker' or matches[2] == 's' then
          savelog(msg.to.id, name_log.." ["..msg.from.id.."] استیکر ممنوع است ")
          return lock_group_sticker(msg, data, target)
      end
      if matches[2] == 'name' or matches[2] == 'n' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] نام گروه قفل است ")
        return lock_group_namemod(msg, data, target)
      end
      if matches[2] == 'member' or matches[2] == 'm' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اضافه شدن ممبر جدید قفل است ")
        return lock_group_membermod(msg, data, target)
        end
      if matches[2] == 'flood' or matches[2] == 'f' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] میزان اسپم قفل است ")
        return lock_group_floodmod(msg, data, target)
      end
      if matches[2] == 'arabic' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] چت کردن قفل است ")
        return lock_group_arabic(msg, data, target)
      end
          if matches[2] == 'adds' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] لینک ورود قفل است ")
        return lock_group_link(msg, data, target)
      end
          if matches[2] == 'eng' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اینگلیسی حرف زدن ممنوع است ")
        return lock_group_eng(msg, data, target)
      end
          if matches[2] == 'tag' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از # ممنوع است ")
        return lock_group_tag(msg, data, target)
      end
         if matches[2] == 'badw' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] کلمات رکیک ممنوع است ")
        return lock_group_badw(msg, data, target)
      end
         if matches[2] == 'join' or matches[2] == 'j' then
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] تبلیغات ممنوع است ")
       return lock_group_adds(msg, data, target)
     end
         if matches[2] == 'leave' then
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] بازگشت به گروه بسته است ")
       return lock_group_leave(msg, data, target)
     end
      if matches[2] == 'bots' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] ورود ربات قفل است ")
        return lock_group_bots(msg, data, target)
      end
    end
    if matches[1] == 'unlock' or matches[1] == 'u'  then
      local target = msg.to.id
      if matches[2] == 'sticker' or matches[2] == 's' then
          savelog(msg.to.id, name_log.." ["..msg.from.id.."] استیکر مجاز است ")
          return unlock_group_sticker(msg, data, target)
      end
      if matches[2] == 'name' or matches[2] == 'n'  then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] نامه گروه باز است ")
        return unlock_group_namemod(msg, data, target)
      end
      if matches[2] == 'member' or matches[2] == 'm' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اضافه شدن ممبر جدید مجاز است ")
        return unlock_group_membermod(msg, data, target)
      end
      if matches[2] == 'photo' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] عکس گروه باز است ")
        return unlock_group_photomod(msg, data, target)
      end
      if matches[2] == 'flood' or matches[2] == 'f' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] میزان اسپم آزاد است ")
        return unlock_group_floodmod(msg, data, target)
      end
      if matches[2] == 'arabic' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] قفله چت باز است ")
        return unlock_group_arabic(msg, data, target)
      end
          if matches[2] == 'adds' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] لینک ورود باز است ")
        return unlock_group_link(msg, data, target)
      end
          if matches[2] == 'eng' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اینگلیسی صحبت کردن مجاز است ")
        return unlock_group_eng(msg, data, target)
      end
          if matches[2] == 'tag' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از # مجاز است ")
        return unlock_group_tag(msg, data, target)
      end
      if matches[2] == 'badw' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از کلمات رکیک مجاز است ")
        return unlock_group_badw(msg, data, target)
      end
        if matches[2] == 'join' or matches[2] == 'j' then
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] تبلیغات در گروه مجاز است ")
       return unlock_group_adds(msg, data, target)
     end
         if matches[2] == 'leave' then
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] بازگشت به گروه باز است ")
       return unlock_group_leave(msg, data, target)
     end
      if matches[2] == 'bots' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] ورود ربات باز است ")
        return unlock_group_bots(msg, data, target)
      end
    end
    if matches[1] == 'settings' then
      local target = msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group settings ")
      return show_group_settingsmod(msg, data, target)
    end	

  --[[if matches[1] == 'public' then
    local target = msg.to.id
    if matches[2] == 'yes' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
      return set_public_membermod(msg, data, target)
    end
    if matches[2] == 'no' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: not public")
      return unset_public_membermod(msg, data, target)
    end
  end]]

    if matches[1] == 'newlink' and not is_realm(msg) then
      if not is_momod(msg) then
        return "فقط مدیرهای گروه میتوانند!"
      end
      local function callback (extra , success, result)
        local receiver = 'chat#'..msg.to.id
        if success == 0 then
           return send_large_msg(receiver, '*خطا: ربات سازنده ی گروه نبوده است .')
        end
        send_large_msg(receiver, "Created a new link")
        data[tostring(msg.to.id)]['settings']['set_link'] = result
        save_data(_config.moderation.data, data)
      end
      local receiver = 'chat#'..msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] revoked group link ")
      return export_chat_link(receiver, callback, true)
    end
    if matches[1] == 'link' then
      if not is_momod(msg) then
        return "فقط مدیرهای گروه میتوانند!"
      end
      local group_link = data[tostring(msg.to.id)]['settings']['set_link']
      if not group_link then 
        return "برای لینک جدید newlink/ را بفرستید !"
      end
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
      return "لینک گروه برای ("..string.gsub(msg.to.print_name, "_", " ")..":\n"..group_link
    end
    if matches[1] == 'setowner' and matches[2] then
      if not is_owner(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد!"
      end
      data[tostring(msg.to.id)]['set_owner'] = matches[2]
      save_data(_config.moderation.data, data)
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
      local text = matches[2].." ادمین اصلی گروه شد"
      return text
    end
    if matches[1] == 'setowner' and not matches[2] then
      if not is_owner(msg) then
        return "!"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, setowner_by_reply, false)
      end
    end
    if matches[1] == 'mega' and  matches[2] == 'satan' then
    	        return "W_SaTaN_W \n Advanced Bot Base On Seed\n@WilSoN_DeVeLoPeR[DeVeLoPeR] \n#Open_Source\n\n[@W_SaTaN](Https://telegra.me/W_SaTaN_W)"
            end
    if matches[1] == 'megasatan' then
    	return "W_SaTaN_W \n Advanced Bot Base On Seed\n@WilSoN_DeVeLoPeR[DeVeLoPeR] \n#Open_Source\n\n[@W_SaTaN](Https://telegra.me/W_SaTaN_W)"
    end
    if matches[1] == 'owner' then
      local group_owner = data[tostring(msg.to.id)]['set_owner']
      if not group_owner then 
        return "no owner,ask admins in support groups to set owner for your group"
      end
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
      return "ادمین اصلی گروه هست ["..group_owner..']'
    end
    if matches[1] == 'setgpowner' then
      local receiver = "chat#id"..matches[2]
      if not is_admin(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد!"
      end
      data[tostring(matches[2])]['set_owner'] = matches[3]
      save_data(_config.moderation.data, data)
      local text = matches[3].." added as owner"
      send_large_msg(receiver, text)
      return
    end
    if matches[1] == 'setflood' then 
      if not is_momod(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد!"
      end
      if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 85 then
        return "Wrong number,range is [2-85]"
      end
      local flood_max = matches[2]
      data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
      save_data(_config.moderation.data, data)
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
      return 'میزان اسپم گروه هست '..matches[2]
    end
    if matches[1] == 'clean' then
      if not is_owner(msg) then
        return "فقط ادمین اصلی گروه میتواند انجام دهد"
      end
      if matches[2] == 'member' then
        if not is_owner(msg) then
          return "فقط ادمین اصلی گروه میتواند انجام دهد"
        end
        local receiver = get_receiver(msg)
        chat_info(receiver, cleanmember, {receiver=receiver})
      end
      if matches[2] == 'modlist' then
        if next(data[tostring(msg.to.id)]['moderators']) == nil then --fix way
          return 'گروه مدیری ندارد.'
        end
        local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
        for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
          data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
          save_data(_config.moderation.data, data)
        end
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
      end
      if matches[2] == 'rules' then 
        local data_cat = 'rules'
        data[tostring(msg.to.id)][data_cat] = nil
        save_data(_config.moderation.data, data)
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
      end
      if matches[2] == 'about' then 
        local data_cat = 'description'
        data[tostring(msg.to.id)][data_cat] = nil
        save_data(_config.moderation.data, data)
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
      end     
    end
    if matches[1] == 'kill' and matches[2] == 'chat' then
      if not is_admin(msg) then
          return nil
      end
      if not is_realm(msg) then
          local receiver = get_receiver(msg)
          return modrem(msg),
          print("Closing Group..."),
          chat_info(receiver, killchat, {receiver=receiver})
      else
          return 'This is a realm'
      end
   end
    if matches[1] == 'kill' and matches[2] == 'realm' then
     if not is_admin(msg) then
         return nil
     end
     if not is_group(msg) then
        local receiver = get_receiver(msg)
        return realmrem(msg),
        print("Closing Realm..."),
        chat_info(receiver, killrealm, {receiver=receiver})
     else
        return 'This is a group'
     end
   end
    if matches[1] == 'help' then
      if not is_momod(msg) or is_realm(msg) then
        return
      end
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /help")
      return help()
    end
    if matches[1] == 'res' and is_momod(msg) then 
      local cbres_extra = {
        chatid = msg.to.id
      }
      local username = matches[2]
      local username = username:gsub("@","")
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /res "..username)
      return res_user(username,  callbackres, cbres_extra)
    end
    if matches[1] == 'kickinactive' then
      --send_large_msg('chat#id'..msg.to.id, 'I\'m in matches[1]')
	    if not is_momod(msg) then
	      return 'Only a moderator can kick inactive users'
	    end
	    local num = 1
	    if matches[2] then
	        num = matches[2]
	    end
	    local chat_id = msg.to.id
	    local receiver = get_receiver(msg)
      return kick_inactive(chat_id, num, receiver)
    end
  end 
end

return {
  patterns = {
  "^[!/](add)$",
  "^[!/](add) (realm)$",
  "^[!/](rem)$",
  "^[!/](rem) (realm)$",
  "^[!/](rules)$",
  "^[!/](about)$",
  "^[!/](setname) (.*)$",
  "^[!/](setphoto)$",
  "^[!/](promote) (.*)$",
  "^[!/](promote)",
  "^[!/](help)$",
  "^[!/](clean) (.*)$",
  "^[!/](kill) (chat)$",
  "^[!/](kill) (realm)$",
  "^[!/](demote) (.*)$",
  "^[!/](demote)",
  "^[!/](set) ([^%s]+) (.*)$",
  "^[!/](lock) (.*)$",
  "^[!/](setowner) (%d+)$",
  "^[!/](setowner)",
  "^[!/](owner)$",
  "^[!/](res) (.*)$",
  "^[!/](setgpowner) (%d+) (%d+)$",-- (group id) (owner id)
  "^[!/](unlock) (.*)$",
  "^[!/](setflood) (%d+)$",
  "^[!/](settings)$",
-- "^[!/](public) (.*)$",
  "^[!/](modlist)$",
  "^[!/](newlink)$",
  "^[!/](link)$",
  "^[!/](kickinactive)$",
  "^[!/](kickinactive) (%d+)$",
  "%[(photo)%]",
  "^!!tgservice (.+)$",
  },
  run = run
}
end
