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

-- Toggle para AutoEgg (0.1s de espera)
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
                        -- Cancelar animações de Tween ou quaisquer outros Animadores
                        local tween = eggOpening:FindFirstChild("Tween")
                        if tween then
                            tween:Cancel()
                        end
                        
                        local animator = eggOpening:FindFirstChildOfClass("Animator")
                        if animator then
                            animator:Stop()
                        end

                        -- Aquele caso onde o Strike também pode ser uma animação
                        local strikeAnimation = eggOpening:FindFirstChild("Strike")
                        if strikeAnimation then
                            -- Cancela qualquer animação de Strike se estiver presente
                            local strikeTween = strikeAnimation:FindFirstChildOfClass("Tween")
                            if strikeTween then
                                strikeTween:Cancel()
                            end
                            local strikeAnimator = strikeAnimation:FindFirstChildOfClass("Animator")
                            if strikeAnimator then
                                strikeAnimator:Stop()
                            end
                        end
                    end
                end
                task.wait(0.1) -- Espera 0.1s antes de repetir
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
local dragging, dragInput, startPos, startMouse
