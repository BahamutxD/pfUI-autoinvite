pfUI:RegisterModule("autoinvite", function ()

  local msg_pref = GetAddOnMetadata("pfUI-autoinvite", "Title") .. "|r: "
  local config

  pfUI.autoinvite = CreateFrame("Frame", "pfAutoinvite", UIParent)
  pfUI.autoinvite:RegisterEvent("VARIABLES_LOADED")
  pfUI.autoinvite.scanner = CreateFrame("Frame", "pfAutoinviteScanner", UIParent)

  local function IsPlayerFromGuild(player_name)
    local name, rank, rankIndex, level, class, zone, note, officernote, online, status
    for i=1, GetNumGuildMembers() do
      name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i)
      if player_name == name then
        return true
      end
    end
    return false
  end

  pfUI.autoinvite.scanner:SetScript("OnEvent", function()
    local invite = false
    local chat_message = arg1
    local player_name = arg2


    if config.state == "1" then
      if config.phrase ~= "" and config.phrase ~= nil then
        if (config.match_case == "1" and arg1 == config.phrase) or (config.match_case == "0" and strupper(arg1) == strupper(config.phrase)) then
          if config.guild_only == "1" then
            if IsPlayerFromGuild(player_name) then
              invite = true
            else
              if config.notification == "1" then
                DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. player_name .. " is not in your guild")
              end
            end
          else
            invite = true
          end
        end
      else
        if config.notification == "1" then
          DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "no phrase has been set")
          return
        end
      end
    else
      return
    end

    if invite then
      arg1 = nil
      arg2 = nil
      -- if not in raid
      if GetNumRaidMembers() == 0 then
        -- if not in group
        if GetNumPartyMembers() == 0 then
          InviteByName(player_name)
          -- arg1 = nil
          if config.notification == "1" then
            DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "invited " .. player_name)
          end
        else
          -- if leader
          if IsPartyLeader() == 1 then
            -- if party is not full
            if GetNumPartyMembers() < 4 then
              InviteByName(player_name)
              -- arg1 = nil
              if config.notification == "1" then
                DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "invited " .. player_name)
              end
            else
              if config.group_type == "raid" then
                ConvertToRaid()
                InviteByName(player_name)
                -- arg1 = nil
                if config.notification == "1" then
                  DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "invited " .. player_name)
                end
              else
                if config.notification == "1" then
                  DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "party is full, cannot invite " .. player_name)
                end
                return
              end
            end
          else
            if config.notification == "1" then
              DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "you're not a leader, cannot invite " .. player_name)
            end
            return
          end
        end
      elseif GetNumRaidMembers() > 0 and GetNumRaidMembers() < 40 then
        if IsRaidOfficer() == 1 then
          InviteByName(player_name)
          arg1 = nil
          if config.notification == "1" then
            DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "invited " .. player_name)
          end
        else
          if config.notification == "1" then
            DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "you're not a leader/officer, cannot invite " .. player_name)
          end
          return
        end
      else
        if config.notification == "1" then
          DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "raid is full, cannot invite " .. player_name)
        end
        return
      end
    else
      -- if config.notification == "1" then
      --   DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "cannot invite " .. player_name)
      -- end
      return
    end
  end)


  -- pfUI.autoinvite:SetScript("OnUpdate", function()
  --   AI_WIM_ChatFrame_OnEvent_ORIG = WIM_ChatFrame_OnEvent
  --   WIM_ChatFrame_OnEvent = AI_WIM_ChatFrame_OnEvent_NEW
  -- end)

  function pfUI.autoinvite:UpdateConfig()
    if config.state == "1" then
      if config.gchat == "1" then
        pfUI.autoinvite.scanner:RegisterEvent("CHAT_MSG_GUILD")
      else
        pfUI.autoinvite.scanner:UnregisterEvent("CHAT_MSG_GUILD")
      end
  
      if config.wchat == "1" then
        pfUI.autoinvite.scanner:RegisterEvent("CHAT_MSG_WHISPER")
      else
        pfUI.autoinvite.scanner:UnregisterEvent("CHAT_MSG_WHISPER")
      end
    else
      pfUI.autoinvite.scanner:UnregisterAllEvents()
    end
  end

  function pfUI.autoinvite:Load()
    config = C.autoinvite
    pfUI.autoinvite:UpdateConfig()
  end


  local function SlashHandler(msg)
    if config.state == "1" then
      config.state = "0"
      DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "disabled")
    else
      config.state = "1"
      DEFAULT_CHAT_FRAME:AddMessage(msg_pref .. "enabled")
    end
    pfUI.autoinvite:UpdateConfig()
    return
  end

  _G.SLASH_PFAI1 = "/pfai"
  _G.SlashCmdList.PFAI = SlashHandler

  pfUI.autoinvite:SetScript("OnEvent", pfUI.autoinvite.Load)

end)
