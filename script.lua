local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local MarketplaceService = game:GetService("MarketplaceService")
local PlaceId = game.PlaceId
local ProductInfo = MarketplaceService:GetProductInfo(PlaceId)
local GameName = ProductInfo.Name

Fluent:Notify({ Title = "Script executado com sucesso", Content = "Você está usando GodHub" })

local Window = Fluent:CreateWindow({
    Title = "GodHub",
    SubTitle = "-- " .. GameName,
    TabWidth = 102,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = false,
    Theme = "dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    AutoEgg = Window:AddTab({ Title = "AutoEgg", Icon = "scroll" }),
    Credits = Window:AddTab({ Title = "Créditos", Icon = "heart" })
}

-- Variável de controle para AutoEgg
local autoEggEnabled = false

-- Toggle para AutoEgg (0.01s de espera)
local eggToggle = Tabs.AutoEgg:AddToggle("EggToggle", {
    Title = "Namek Island Egg",
    Default = false
})

eggToggle:OnChanged(function(state)
    autoEggEnabled = state
    if autoEggEnabled then
        task.spawn(function()
            while autoEggEnabled do
                local map = workspace.Client.Maps:FindFirstChild("Namek Island")
                if map and map:FindFirstChild("Summon") and map.Summon:FindFirstChild("Currency") then
                    local args = {
                        [1] = "Summon",
                        [2] = "Summon",
                        [3] = {
                            ["Instance"] = map.Summon.Currency,
                            ["Map"] = "Namek Island"
                        },
                        [4] = "Multi"
                    }
                    game:GetService("ReplicatedStorage").Bridge:FireServer(unpack(args))

                    -- Tentar pular a animação de abertura do Egg
                    local eggOpening = workspace:FindFirstChild("EggOpening")
                    if eggOpening then
                        if eggOpening:FindFirstChild("Tween") then
                            eggOpening.Tween:Cancel()
                        end
                    end
                end
                task.wait(0.01) -- Espera 0.01s antes de repetir
            end
        end)
    end
end)

-- Aba de Créditos
Tabs.Credits:AddParagraph({
    Title = "Feito por:",
    Content = "GodHub"
})

Tabs.Credits:AddParagraph({
    Title = "Parceiros:",
    Content = "Mender Hub"
})

-- Botão Flutuante para Abrir/Fechar o Menu
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.005, 0, 0.010, 0)
ImageButton.Size = UDim2.new(0, 45, 0, 45)
ImageButton.Image = "rbxassetid://118885851320276" -- ID do ícone

UICorner.Parent = ImageButton

-- Função para tornar o botão arrastável
local UIS = game:GetService("UserInputService")
local dragging, dragInput, startPos, startMousePos
local hasMoved = false

ImageButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        hasMoved = false
        startPos = ImageButton.Position
        startMousePos = UIS:GetMouseLocation()

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ImageButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = UIS:GetMouseLocation() - startMousePos
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then 
            hasMoved = true
        end
        ImageButton.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

ImageButton.MouseButton1Down:Connect(function()
    task.wait(0.1) -- Espera para evitar abrir ao arrastar
    if not hasMoved then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    end
end)
