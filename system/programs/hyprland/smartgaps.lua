-------------------------------------------
---- SMART GAPS / NO GAPS WHEN ONLY -------
-------------------------------------------
-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local smartgap_ws_rules = {
  hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 }),
  hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 }),
}

local smartgap_win_rules = {
  hl.window_rule({ name = "smartgaps-border-tv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0 }),
  hl.window_rule({ name = "smartgaps-rounding-tv1", match = { float = false, workspace = "w[tv1]" }, rounding = 0 }),
  hl.window_rule({ name = "smartgaps-border-f1", match = { float = false, workspace = "f[1]" }, border_size = 0 }),
  hl.window_rule({ name = "smartgaps-rounding-f1", match = { float = false, workspace = "f[1]" }, rounding = 0 }),
}

hl.bind(mod .. " + M", function()
  -- toggle all smart gap rules
  local enabled = smartgap_win_rules[1]:is_enabled()
  local new_state = not enabled

  for _, rule in ipairs(smartgap_ws_rules) do
    rule:set_enabled(new_state)
  end
  for _, rule in ipairs(smartgap_win_rules) do
    rule:set_enabled(new_state)
  end
end)
