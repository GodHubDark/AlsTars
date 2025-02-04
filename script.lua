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
