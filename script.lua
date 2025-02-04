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
    AutoEgg = Window:AddTab({ Title = "AutoEgg", Icon = "scroll" })
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

                    -- Pular todas as animações do personagem
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("Humanoid") then
                        local humanoid = character.Humanoid
                        -- Desabilita as animações do humanoide
                        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                        humanoid.AutoRotate = false
                        humanoid.PlatformStand = true

                        -- Se você quiser, pode redefinir o estado do personagem para um "parado"
                        humanoid:Move(Vector3.new(0, 0, 0)) -- Mover o personagem para um local fixo (ignorar movimento)

                        -- Desabilitar o Animator para pular animações
                        local animator = character:FindFirstChildOfClass("Animator")
                        if animator then
                            animator:Stop()
                        end
                    end
                end
                task.wait(0.01) -- Espera 0.01s antes de repetir
            end
        end)
    end
end)
