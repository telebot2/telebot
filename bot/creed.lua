package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utils")

VERSION = '1.0'

-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  local receiver = get_receiver(msg)
  print (receiver)

  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
  --   mark_read(receiver, ok_cb, false)
    end
  end
end

function ok_cb(extra, success, result)
end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)

  _config = load_config()

  -- load plugins
  plugins = {}
  load_plugins()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end

  -- Before bot was started
  if msg.date < now then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end

  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end

  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end

  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end

  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end

  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end

  if msg.from.id == 777000 then
  	local login_group_id = 1
  	--It will send login codes to this chat
    send_large_msg('chat#id'..login_group_id, msg.text)
  end

  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end

  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        send_msg(receiver, warning, ok_cb, false)
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Allowed user: " .. user)
  end
  return config
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "onservice",
    "inrealm",
    "ingroup",
    "inpm",
    "banhammer",
    "Boobs",
    "Feedback",
    "lock_join",
    "antilink",
    "antitag",
    "gps",
    "auto_leave",
    "block",
    "tagall",
    "arabic_lock",
    "welcome",
    "google",
    "sms",
    "chat",
    "Debian_service",
    "sudoers",
    "add_admin",
    "anti_spam",
    "add_bot",
    "owners",
    "set",
    "get",
    "broadcast",
    "download_media",
    "invite",
    "all",
    "leave_ban",
    "danestaniha",
    "joke",
    "nerkh",
    "echo",
    "linkpv"
    },
    sudo_users = {135693512},--Sudo users
    disabled_channels = {},
    moderation = {data = 'data/moderation.json'},
    about_text = [[Creed bot 2.3
    
     Hello my Good friends 
     
    ‼️ this bot is made by : @DARK_BOYS_ADMIN
   〰〰〰〰〰〰〰〰
   ߔࠀ   our admins are :
         @DARK_BOYS_ADMIN
   〰〰〰〰〰〰〰〰
  ♻️ You can send your Ideas and messages to Us By sending them into bots account by this command :
   تمامی درخواست ها و همه ی انتقادات و حرفاتونو با دستور زیر بفرستین به ما
   !feedback (your ideas and messages)
]],
    help_text = [[
                              ������لیست دستورات :
__________________________
!kick [آیدی،کد،ریپلای] 
            شخص مورد نظر از گروه اخراج ميشود.
------------------------------------------
!ban [آیدی،کد،ریپلای]
                 شخص مورد نظر از گروه بن شود
------------------------------------------
!banlist
                           لیست افراد بن شده
------------------------------------------
!unban                        در آوردن از بن 
------------------------------------------
!kickme                             ترک گروه
------------------------------------------
!owner                  نمایش آیدی مدیر گروه
------------------------------------------
!modlist                     لیست کمک مدیرها
------------------------------------------
!promote [ریپلای،یوزرنیم]
                         اضافه کردن کمک مدیر
------------------------------------------
!demote [ریپلای،یوزرنیم]
                           حذف کردن کمک مدیر
------------------------------------------
!lock [bots-member-flood-photo-name-tag-link-join-Arabic]
 
            قفل اعضا ، نام گروه ، ربات و ...
------------------------------------------
!unlock [bots-member-flood-photo-name-tag-link-join-Arabic]

          باز کردن قفل اعضا ، نام گروه و ...
------------------------------------------
!lock adds
            جلو گیری از گذاشتن  هر نوع لینکی
------------------------------------------
!lock tag
                جلو گیری از استفاده ی  # و @
------------------------------------------
!lock eng
                 جلو گیری از انگلیسی حرف زدن 
------------------------------------------
!lock leave
                    جلو گیری از حرف های رکیک 
------------------------------------------
!lock join
برای جلو گیری از وارد شدن شخصی به گروه با لینک
------------------------------------------
!calc 2+8
                         انجام محاسبات ریاضی
------------------------------------------
!feedback [متن پیام]
                     ارتباط با پشتیبانی ربات
------------------------------------------
!setphoto           اضافه کردن وقفل عکس گروه
------------------------------------------
!setname [نام] 
                           عوض کردن نام گروه
------------------------------------------
!about                           درباره گروه
------------------------------------------
!rules                           قوانین گروه
------------------------------------------
!set rules <متن>
                             متن قوانین گروه

------------------------------------------
!set about <متن> 
                             متن درباره گروه
------------------------------------------
!settings                       تنظیمات گروه
------------------------------------------
!newlink           تعویض لینک و ارسال درگروه
------------------------------------------
!linkpv                  ارسال لینک در پی وی        
------------------------------------------
!link                              لینک گروه
------------------------------------------
!setflood [تعداد]
                          محدودیت تعداد اسپم
------------------------------------------
!set [کلمه] <text> 
                           ذخیره کلمه و جمله 
------------------------------------------
!get [کلمه]
            جمله ای که برای کلمه ذخیره کردید
------------------------------------------
!clean [modlist|rules|about|member]
         پاک سازی/ممبرها/قوانین/موضوع/مدیران
------------------------------------------
!res [یوزرنیم]
                             گرفتن  آیدی فرد
------------------------------------------
!id                               گرفتن آیدی
------------------------------------------
!log                             اطلاعات گروه
------------------------------------------
!stats                     آمار در پیام ساده
------------------------------------------
!who                              لیست اعضاء  
------------------------------------------
!echo                      <متن> : تکرار متن
------------------------------------------
!tagall                  صدا کردن افراد گروه
------------------------------------------
⚠️  شما ميتوانيد از ! و / استفاده کنيد. 
------------------------------------------
]]

  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)

end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
      print('\27[31m'..err..'\27[39m')
    end

  end
end


-- custom add
function load_data(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 2 mins
  postpone (cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
