-- ============================
-- DISPLAYNAME ESP - MM2
-- Rojo Murderer / Azul Sheriff / Verde Innocent
-- Tamaño fijo 20 + borde negro
-- Compatible con HIGHLIGHT_ME
-- ============================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().DISPLAY_ESP_ENABLED =
    not (getgenv().DISPLAY_ESP_ENABLED or false)

local PREFIX = "DISPLAY_ESP_"
local ROLE_TEXT_PREFIX = "ROLE_TEXT_"

-- ============================
-- ELIMINAR TEXTO
-- ============================

local function removeESP(plr)
    local gui = CoreGui:FindFirstChild(PREFIX .. plr.Name)

    if gui then
        gui:Destroy()
    end
end

-- ============================
-- ACTUALIZAR ESP
-- ============================

local function updateESP(plr)
    if not plr or not plr.Parent then return end

    local guiName = PREFIX .. plr.Name
    local gui = CoreGui:FindFirstChild(guiName)

    -- Respetar HIGHLIGHT_ME
    if plr == LocalPlayer and getgenv().HIGHLIGHT_ME == false then
        removeESP(plr)
        return
    end

    local roleTable = getgenv().ROLE_TABLE or {}
    local data = roleTable[plr.Name]
    local role = data and data.Role

    -- No duplicar el texto Murderer del otro ESP
    if role == "Murderer" then
        removeESP(plr)
        return
    end

    local char = plr.Character
    if not char then
        removeESP(plr)
        return
    end

    local head = char:FindFirstChild("Head")
    if not head then
        removeESP(plr)
        return
    end

    if not getgenv().DISPLAY_ESP_ENABLED then
        removeESP(plr)
        return
    end

    -- Crear BillboardGui
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = guiName
        gui.Size = UDim2.fromOffset(200, 30)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = head
        gui.Parent = CoreGui

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.TextScaled = false
        label.TextSize = 20
        label.Font = Enum.Font.GothamBold

        -- Borde negro
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0

        label.Parent = gui
    end

    gui.Adornee = head

    local label = gui:FindFirstChild("Label")
    if not label then return end

    label.Text = plr.DisplayName

    -- Colores MM2
    if role == "Sheriff" then
        label.TextColor3 = Color3.fromRGB(0, 120, 255)
    elseif role == "Innocent" then
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        -- Si el rol todavía no está disponible
        label.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

-- ============================
-- LOOP PRINCIPAL
-- ============================

task.spawn(function()
    while true do
        if getgenv().DISPLAY_ESP_ENABLED then
            for _, plr in ipairs(Players:GetPlayers()) do
                updateESP(plr)
            end
        else
            for _, gui in ipairs(CoreGui:GetChildren()) do
                if gui.Name:match("^DISPLAY_ESP_") then
                    gui:Destroy()
                end
            end
        end

        task.wait(0.25)
    end
end)

Players.PlayerRemoving:Connect(removeESP)
