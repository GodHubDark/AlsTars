local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local MarketplaceService = game:GetService("MarketplaceService")
local PlaceId = game.PlaceId
local ProductInfo = MarketplaceService:GetProductInfo(PlaceId)
local GameName = ProductInfo.Name

local Window = Fluent:CreateWindow({
    Title = "GodHub",
    SubTitle = "-- " .. GameName,
    TabWidth = 102,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = false,
    Theme = "aqua", -- Tema Aqua aplicado
    MinimizeKey = Enum.KeyCode.LeftControl -- Atalho para abrir/fechar
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

                    -- Espera ajustada para 0.01s ao tentar pular a animação do Egg
                    task.wait(0.01)

                    -- Tentar pular a animação de abertura do Egg
                    local eggOpening = workspace:FindFirstChild("EggOpening")
                    if eggOpening then
                        local animator = eggOpening:FindFirstChildOfClass("Animator")
                        if animator then
                            animator:Stop()
                        end

                        if eggOpening:FindFirstChild("Animation") then
                            local animation = eggOpening.Animation
                            if animation:IsA("Animation") then
                                local animationTrack = animation:FindFirstChildOfClass("AnimationTrack")
                                if animationTrack then
                                    animationTrack:Stop()
                                end
                            end
                        end
                    end
                end
                task.wait(0.01) -- Espera agora é 0.01s antes de repetir
            end
        end)
    end
end)

-- Aba de Créditos
Tabs.Credits:AddParagraph({ Title = "Feito por:", Content = "GodHub" })
Tabs.Credits:AddParagraph({ Title = "Parceiros:", Content = "Mender Hub" })
