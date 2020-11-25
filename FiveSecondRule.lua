local f = CreateFrame("frame",nil,UIParent)

f:SetFrameStrata("BACKGROUND")
f:SetWidth(128)
f:SetHeight(20)
f.texture = f:CreateTexture(nil,"BACKGROUND")
f.texture:SetAllPoints(f)
f.texture:SetColorTexture(0.1, 0.1, 0.1, 0.5)
f:SetPoint("LEFT",0,0)
f:Show()

-- trigger on spellcast
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

local statusbar = CreateFrame("StatusBar", nil, UIParent)
statusbar:SetFrameStrata("BACKGROUND")
statusbar:SetWidth(128)
statusbar:SetHeight(20)
statusbar:SetPoint("LEFT",0,0)
statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar:SetStatusBarColor(0, 0.65, 0)
statusbar:SetMinMaxValues(0, 5)

f:SetScript("OnEvent", function(self, event, ...)

    if event == "UNIT_SPELLCAST_SUCCEEDED" then

        -- get spell details
        local arg1, arg2, spellID = ...
        costs = GetSpellPowerCost(spellID)

        -- only trigger statusbar if spell cost mana
        if costs[1]["name"] == "MANA" then

            -- reset status bar, get current time
            local curr_time = GetTime()
            local end_time = GetTime() + 5
            local iter_freq = .05
            statusbar:SetValue(0)
            statusbar:SetStatusBarColor(1, 0, 0)

            -- get system time every ~ 0.05 seconds,
            -- and update status bar.
            -- (GetTime() was much more accurate than
            -- NewTicker, which lagged quite a bit)
            local my_ticker = C_Timer.NewTicker(iter_freq,
                function()
                    elapsed = 5 - (end_time - GetTime())
                    statusbar:SetValue(elapsed)
                end,
                100
            )

            -- five seconds after cast, reset status bar
            local colorReset = C_Timer.After(5,
                function()
                    my_ticker:Cancel()
                    statusbar:SetStatusBarColor(0, 0.35, 0)
                    statusbar:SetValue(5)
                end
            )
        end
    end
end)