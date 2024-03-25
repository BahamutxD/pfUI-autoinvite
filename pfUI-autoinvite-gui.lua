-- load pfUI environment
setfenv(1, pfUI:GetEnvironment())

function pfUI.autoinvite:LoadGui()
  if not pfUI.gui then return end

  local function CreateSlashCmdLine(parent, index, cmd, description)
    parent.cmds = parent.cmds or {}
    if parent.cmds[index] then return end
    parent.cmds[index] = {}
    parent.cmds[index].cmd = parent:CreateFontString("Status", "LOW", "GameFontWhite")
    parent.cmds[index].cmd:SetFont(pfUI.font_default, C.global.font_size)
    parent.cmds[index].cmd:SetText("|cff33ffcc" .. cmd .. "|r")
    parent.cmds[index].cmd:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", - (parent:GetWidth() * 0.8), - (tonumber(C.global.font_size) * 2) * index)

    if description and description ~= "" then
      parent.cmds[index].desc = parent:CreateFontString("Status", "LOW", "GameFontWhite")
      parent.cmds[index].desc:SetFont(pfUI.font_default, C.global.font_size)
      parent.cmds[index].desc:SetText(" - " .. description)
      parent.cmds[index].desc:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", (parent:GetWidth() * 0.2), - (tonumber(C.global.font_size) * 2) * index)
    end

    parent:GetParent().objectCount = parent:GetParent().objectCount + 1
  end

  local old_gui = true
  
  if pfUI.gui.CreateGUIEntry then
    old_gui = false
  end

  pfUI.gui.dropdowns.autoinvite_grouptype = {
    "raid:" .. T["Raid"],
    "party:" .. T["Party"],
  }

  if old_gui then
    local CreateConfig = pfUI.gui.CreateConfig
    local update = pfUI.gui.update
  
    if pfUI.gui.tabs.thirdparty then
      pfUI.gui.tabs.thirdparty.tabs.autoinvite = pfUI.gui.tabs.thirdparty.tabs:CreateTabChild(GetAddOnMetadata("pfUI-autoinvite", "X-LocalName"), true)
      pfUI.gui.tabs.thirdparty.tabs.autoinvite:SetScript("OnShow", function()
        if not this.setup then
          CreateConfig(update["autoinvite"], this, T["Enable Autoinvites"], C.autoinvite, "state", "checkbox")
          CreateConfig(update["autoinvite"], this, T["Match Case"], C.autoinvite, "match_case", "checkbox")
          CreateConfig(update["autoinvite"], this, T["Autoinvite Phrase"], C.autoinvite, "phrase", "text", nil, nil, nil, "text")
          CreateConfig(update["autoinvite"], this, T["Group Type"], C.autoinvite, "group_type", "dropdown", pfUI.gui.dropdowns.autoinvite_grouptype)
          CreateConfig(update["autoinvite"], this, T["Scan Whispers"], C.autoinvite, "wchat", "checkbox")
          CreateConfig(update["autoinvite"], this, T["Scan Guild Chat"], C.autoinvite, "gchat", "checkbox")
          CreateConfig(update["autoinvite"], this, T["Autoinvite Only Guild Members"], C.autoinvite, "guild_only", "checkbox")
          CreateConfig(update["autoinvite"], this, T["Show Notifications"], C.autoinvite, "notification", "checkbox")

          CreateConfig(update[c], this, T["SLASH COMMANDS:"], nil, nil, "header")
          CreateConfig(update[c], this, T["/pfai"], nil, nil, "header", nil, true)

          this.setup = true 
        end
      end)
    end
  else
    local Reload = pfUI.gui.Reload
    local CreateConfig = pfUI.gui.CreateConfig
    local CreateGUIEntry = pfUI.gui.CreateGUIEntry
    local U = pfUI.gui.UpdaterFunctions
    
    CreateGUIEntry(T["Thirdparty"], GetAddOnMetadata("pfUI-autoinvite", "X-LocalName"), function()
      CreateConfig(U["autoinvite"], T["Enable Autoinvites"], C.autoinvite, "state", "checkbox")
      CreateConfig(U["autoinvite"], T["Match Case"], C.autoinvite, "match_case", "checkbox")
      CreateConfig(U["autoinvite"], T["Autoinvite Phrase"], C.autoinvite, "phrase", "text", nil, nil, nil, "text")
      CreateConfig(U["autoinvite"], T["Group Type"], C.autoinvite, "group_type", "dropdown", pfUI.gui.dropdowns.autoinvite_grouptype)
      CreateConfig(U["autoinvite"], T["Scan Whispers"], C.autoinvite, "wchat", "checkbox")
      CreateConfig(U["autoinvite"], T["Scan Guild Chat"], C.autoinvite, "gchat", "checkbox")
      CreateConfig(U["autoinvite"], T["Autoinvite Only Guild Members"], C.autoinvite, "guild_only", "checkbox")
      CreateConfig(U["autoinvite"], T["Show Notifications"], C.autoinvite, "notification", "checkbox")

      local slash_header = CreateConfig(nil, T["SLASH COMMANDS"], nil, nil, "header")
      CreateSlashCmdLine(slash_header, 1, "/pfai", "Enable/Disable autoinvites")

      CreateConfig(nil, T["Version"] .. ": " .. GetAddOnMetadata("pfUI-autoinvite", "Version"), nil, nil, "header")
      CreateConfig(U["autoinvite"], T["Website"], nil, nil, "button", function()
        pfUI.chat.urlcopy.CopyText("https://gitlab.com/dein0s_wow_vanilla/pfUI-autoinvite")
      end)

    end)
  end
end

pfUI.autoinvite:LoadGui()
