--// Configurações
local Settings = {
    BoxThickness = 1.4, -- Espessura da caixa
    BoxTransparency = 1, -- 1 = Visível, 0 = Invisível

    Healthbar = true, -- Ativar Healthbar
    HealthbarThickness = 2, -- Espessura da Healthbar
    HealthbarTransparency = 1, -- 1 = Visível, 0 = Invisível

    Autothickness = false, -- Ajustar espessura automaticamente
    TeamCheck = true, -- Ativar verificação de equipe
    ShowName = true -- Mostrar o nome do jogador
}

--// Serviços
local Players = game:GetService("Players")
local Teams = game:GetService("Teams") -- Serviço de equipes
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Tabela para armazenar as linhas, a Healthbar e o nome de cada jogador
local ESPObjects = {}

--// Tabela para armazenar as cores das equipes
local TeamColors = {}

--// Função para criar uma nova linha
local function NewLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(1, 1)
    line.Thickness = Settings.BoxThickness
    line.Transparency = Settings.BoxTransparency
    return line
end

--// Função para criar uma nova Healthbar
local function NewHealthbar()
    local healthbar = Drawing.new("Line")
    healthbar.Visible = false
    healthbar.From = Vector2.new(0, 0)
    healthbar.To = Vector2.new(0, 0)
    healthbar.Thickness = Settings.HealthbarThickness
    healthbar.Transparency = Settings.HealthbarTransparency
    return healthbar
end

--// Função para criar um novo texto (nome do jogador)
local function NewText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Text = ""
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.new(1, 1, 1) -- Cor branca
    return text
end

--// Função para obter a cor de uma equipe com base no nome
local function GetTeamColor(team)
    if TeamColors[team.Name] then
        return TeamColors[team.Name] -- Retorna a cor já registrada
    else
        -- Usa a cor da equipe definida no Roblox
        TeamColors[team.Name] = team.TeamColor.Color
        return team.TeamColor.Color
    end
end

--// Função para inicializar o ESP para um jogador
local function ESP(player)
    local lines = {
        line1 = NewLine(),
        line2 = NewLine(),
        line3 = NewLine(),
        line4 = NewLine(),
        line5 = NewLine(),
        line6 = NewLine(),
        line7 = NewLine(),
        line8 = NewLine(),
        line9 = NewLine(),
        line10 = NewLine(),
        line11 = NewLine(),
        line12 = NewLine()
    }

    local healthbar = NewHealthbar()
    local nameText = NewText()

    ESPObjects[player] = {lines = lines, healthbar = healthbar, nameText = nameText}

    local function Update()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if vis then
                    local Scale = player.Character.Head.Size.Y / 2
                    local Size = Vector3.new(2, 3, 1.5) * (Scale * 2) -- Tamanho da caixa

                    -- Pontos da caixa 3D
                    local Top1 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, -Size.Z)).p)
                    local Top2 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, Size.Z)).p)
                    local Top3 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, Size.Z)).p)
                    local Top4 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, -Size.Z)).p)

                    local Bottom1 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, -Size.Z)).p)
                    local Bottom2 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, Size.Z)).p)
                    local Bottom3 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, Size.Z)).p)
                    local Bottom4 = Camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, -Size.Z)).p)

                    -- Atualizar as linhas da caixa
                    lines.line1.From = Vector2.new(Top1.X, Top1.Y)
                    lines.line1.To = Vector2.new(Top2.X, Top2.Y)

                    lines.line2.From = Vector2.new(Top2.X, Top2.Y)
                    lines.line2.To = Vector2.new(Top3.X, Top3.Y)

                    lines.line3.From = Vector2.new(Top3.X, Top3.Y)
                    lines.line3.To = Vector2.new(Top4.X, Top4.Y)

                    lines.line4.From = Vector2.new(Top4.X, Top4.Y)
                    lines.line4.To = Vector2.new(Top1.X, Top1.Y)

                    lines.line5.From = Vector2.new(Bottom1.X, Bottom1.Y)
                    lines.line5.To = Vector2.new(Bottom2.X, Bottom2.Y)

                    lines.line6.From = Vector2.new(Bottom2.X, Bottom2.Y)
                    lines.line6.To = Vector2.new(Bottom3.X, Bottom3.Y)

                    lines.line7.From = Vector2.new(Bottom3.X, Bottom3.Y)
                    lines.line7.To = Vector2.new(Bottom4.X, Bottom4.Y)

                    lines.line8.From = Vector2.new(Bottom4.X, Bottom4.Y)
                    lines.line8.To = Vector2.new(Bottom1.X, Bottom1.Y)

                    lines.line9.From = Vector2.new(Bottom1.X, Bottom1.Y)
                    lines.line9.To = Vector2.new(Top1.X, Top1.Y)

                    lines.line10.From = Vector2.new(Bottom2.X, Bottom2.Y)
                    lines.line10.To = Vector2.new(Top2.X, Top2.Y)

                    lines.line11.From = Vector2.new(Bottom3.X, Bottom3.Y)
                    lines.line11.To = Vector2.new(Top3.X, Top3.Y)

                    lines.line12.From = Vector2.new(Bottom4.X, Bottom4.Y)
                    lines.line12.To = Vector2.new(Top4.X, Top4.Y)

                    -- Atualizar a Healthbar
                    if Settings.Healthbar then
                        local health = player.Character.Humanoid.Health
                        local maxHealth = player.Character.Humanoid.MaxHealth
                        local healthRatio = health / maxHealth

                        local barLength = (Top1.Y - Bottom1.Y) * healthRatio
                        healthbar.From = Vector2.new(Bottom1.X - 10, Bottom1.Y)
                        healthbar.To = Vector2.new(Bottom1.X - 10, Bottom1.Y - barLength)
                        healthbar.Color = Color3.new(1 - healthRatio, healthRatio, 0) -- Verde para vida cheia, vermelho para vida baixa
                        healthbar.Visible = true
                    end

                    -- Verificação de equipe
                    if Settings.TeamCheck then
                        local team = player.Team
                        if team then
                            local color = GetTeamColor(team) -- Obtém a cor da equipe
                            for _, line in pairs(lines) do
                                line.Color = color -- Define a cor da caixa
                            end
                            nameText.Color = color -- Define a cor do texto
                        end
                    else
                        for _, line in pairs(lines) do
                            line.Color = Color3.new(1, 1, 1) -- Branco se o TeamCheck estiver desativado
                        end
                        nameText.Color = Color3.new(1, 1, 1) -- Branco se o TeamCheck estiver desativado
                    end

                    -- Atualizar o nome do jogador
                    if Settings.ShowName then
                        nameText.Text = player.Name
                        nameText.Position = Vector2.new(pos.X, pos.Y - (Top1.Y - Bottom1.Y) / 2 - 20) -- Posiciona acima da caixa
                        nameText.Visible = true
                    else
                        nameText.Visible = false
                    end

                    -- Ajustar espessura automaticamente
                    if Settings.Autothickness then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
                        local thickness = math.clamp(1 / distance * 100, 0.1, 4) -- 0.1 é a espessura mínima, 4 é a máxima
                        for _, line in pairs(lines) do
                            line.Thickness = thickness
                        end
                        healthbar.Thickness = thickness
                    else
                        for _, line in pairs(lines) do
                            line.Thickness = Settings.BoxThickness
                        end
                        healthbar.Thickness = Settings.HealthbarThickness
                    end

                    -- Tornar as linhas visíveis
                    for _, line in pairs(lines) do
                        line.Visible = true
                    end
                else
                    -- Tornar as linhas invisíveis se o jogador não estiver na tela
                    for _, line in pairs(lines) do
                        line.Visible = false
                    end
                    healthbar.Visible = false
                    nameText.Visible = false
                end
            else
                -- Tornar as linhas invisíveis se o jogador não for válido
                for _, line in pairs(lines) do
                    line.Visible = false
                end
                healthbar.Visible = false
                nameText.Visible = false
                if not Players:FindFirstChild(player.Name) then
                    connection:Disconnect() -- Parar de atualizar se o jogador sair do jogo
                    ESPObjects[player] = nil -- Remover da tabela
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

--// Inicializar ESP para todos os jogadores
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        coroutine.wrap(ESP)(player)
    end
end

--// Inicializar ESP para novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        coroutine.wrap(ESP)(player)
    end
end)

--// Remover ESP quando um jogador sair
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, line in pairs(ESPObjects[player].lines) do
            line:Remove() -- Remover as linhas
        end
        ESPObjects[player].healthbar:Remove() -- Remover a Healthbar
        ESPObjects[player].nameText:Remove() -- Remover o texto
        ESPObjects[player] = nil -- Limpar da tabela
    end
end)
