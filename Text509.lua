-- ======================
-- DISPLAYNAME ESP
-- ROLE_TABLE COLOR VERSION
-- ======================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

getgenv().DISPLAY_ESP_ENABLED =
    not (getgenv().DISPLAY_ESP_ENABLED or false)

local PREFIX = "DISPLAY_ESP_"

-- ======================
-- ELIMINAR ESP
-- ======================

local function removeESP(plr)
    local gui = CoreGui:FindFirstChild(PREFIX .. plr.Name)

    if gui then
        gui:Destroy()
    end
end

-- ======================
-- ACTUALIZAR ESP
-- ======================

local function updateESP(plr)
    if not plr or not plr.Parent then return end

    local char = plr.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    local guiName = PREFIX .. plr.Name
    local gui = CoreGui:FindFirstChild(guiName)

    if not getgenv().DISPLAY_ESP_ENABLED then
        if gui then
            gui:Destroy()
        end
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

    -- Actualizar cabeza
    gui.Adornee = head

    local label = gui:FindFirstChild("Label")
    if not label then return end

    -- DisplayName
    label.Text = plr.DisplayName

    -- Obtener tabla actualizada
    local roleTable = getgenv().ROLE_TABLE or {}
    local data = roleTable[plr.Name]

    -- Color desde ROLE_TABLE
    if data and typeof(data.Color) == "Color3" then
        label.TextColor3 = data.Color
    else
        label.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

-- ======================
-- LOOP PRINCIPAL
-- ======================

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

-- Limpiar al salir
Players.PlayerRemoving:Connect(removeESP)
