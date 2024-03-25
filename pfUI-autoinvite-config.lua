--                MODULE        SUBGROUP       ENTRY               VALUE
-- pfUI:UpdateConfig("module_template", nil, nil, 0)

-- load pfUI environment
setfenv(1, pfUI:GetEnvironment())

function pfUI.autoinvite:LoadConfig()
  pfUI:UpdateConfig("autoinvite", nil,           "state",            "0")
  pfUI:UpdateConfig("autoinvite", nil,           "match_case",       "0")
  pfUI:UpdateConfig("autoinvite", nil,           "gchat",            "0")
  pfUI:UpdateConfig("autoinvite", nil,           "wchat",            "1")
  pfUI:UpdateConfig("autoinvite", nil,           "guild_only",       "1")
  pfUI:UpdateConfig("autoinvite", nil,           "group_type",       "raid")
  pfUI:UpdateConfig("autoinvite", nil,           "phrase",           "")
  pfUI:UpdateConfig("autoinvite", nil,           "notification",     "1")
end

pfUI.autoinvite:LoadConfig()
