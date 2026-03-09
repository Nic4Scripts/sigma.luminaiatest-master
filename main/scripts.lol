local Luminaia = {
    Windows = {},
    Flags = {},
    Toggled = false,
    User = "Prizmm",
    Accent = Color3.fromRGB(255, 255, 255)
}

local UIS = game:GetService("UserInputService")

function Luminaia.Draw(objType, props)
    local obj = Drawing.new(objType)
    for i, v in pairs(props) do obj[i] = v end
    return obj
end

function Luminaia:CreateWindow(name)
    local Window = {Elements = {}, Visible = false, YOffset = 38}
    local XPos = 50 + (#self.Windows * 110)

    Window.Drawings = {
        Main = Luminaia.Draw("Square", {Size = Vector2.new(95, 1000), Position = Vector2.new(XPos, 50), Color = Color3.fromRGB(15, 15, 15), Filled = true, Visible = false, Transparency = 0.9, ZIndex = 100}),
        Header = Luminaia.Draw("Square", {Size = Vector2.new(95, 30), Position = Vector2.new(XPos, 50), Color = Color3.fromRGB(25, 25, 25), Filled = true, Visible = false, ZIndex = 101}),
        Title = Luminaia.Draw("Text", {Text = name:upper(), Size = 14, Center = true, Outline = true, Position = Vector2.new(XPos + 47, 58), Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 102})
    }

    function Window:AddToggle(text, flag, default, callback)
        local Y = Window.Drawings.Main.Position.Y + Window.YOffset
        local Label = Luminaia.Draw("Text", {Text = text, Size = 12, Position = Vector2.new(XPos + 5, Y), Color = default and Luminaia.Accent or Color3.new(0.7, 0.7, 0.7), Visible = false, Outline = true, ZIndex = 105})
        
        Luminaia.Flags[flag] = default
        UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and Window.Visible then
                local m = UIS:GetMouseLocation()
                if m.X >= Label.Position.X and m.X <= Label.Position.X + 85 and m.Y >= Label.Position.Y and m.Y <= Label.Position.Y + 14 then
                    Luminaia.Flags[flag] = not Luminaia.Flags[flag]
                    Label.Color = Luminaia.Flags[flag] and Luminaia.Accent or Color3.new(0.7, 0.7, 0.7)
                    callback(Luminaia.Flags[flag])
                end
            end
        end)
        Window.YOffset = Window.YOffset + 18
        return Label
    end

    function Window:SetVisible(state)
        Window.Visible = state
        for _, d in pairs(Window.Drawings) do d.Visible = state end
        -- Elements are simpler now
    end

    table.insert(Luminaia.Windows, Window)
    return Window
end

function Luminaia:Notify(msg) print("[LUMINAIA] " .. msg) end

function Luminaia:ToggleUI()
    self.Toggled = not self.Toggled
    for _, win in pairs(self.Windows) do win:SetVisible(self.Toggled) end
end

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then Luminaia:ToggleUI() end
end)

return Luminaia
