--// Configurações
local Settings = {
    HighlightTransparency = 0.5, -- Transparência do realce (0 = totalmente visível, 1 = invisível)
    HighlightColor = Color3.new(1, 0, 0), -- Cor do realce (vermelho por padrão)

    Healthbar = true, -- Ativar Healthbar
    HealthbarThickness = 2, -- Espessura da Healthbar
    HealthbarTransparency = 1, -- 1 = Visível, 0 = Invisível

    TeamCheck = true, -- Ativar verificação de equipe
    ShowName = true -- Mostrar o nome do jogador
}

--// Serviços
local Players = game:GetService("Players")
local Teams = game:GetService("Teams") -- Serviço de equipes
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Tabela para armazenar os realces, a Healthbar e o nome de cada jogador
local ESPObjects = {}

--// Função para criar um novo realce (Highlight)
local function NewHighlight()
    local highlight = Instance.new("Highlight")
    highlight.Adornee = nil
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Garante que o realce fique sempre visível
    highlight.FillTransparency = Settings.HighlightTransparency
    highlight.OutlineTransparency = 0
    highlight.FillColor = Settings.HighlightColor
    highlight.OutlineColor = Settings.HighlightColor
    highlight.Parent = game.CoreGui
    return highlight
end

--// Função para criar um novo texto (nome do jogador)
local function NewText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Text = ""
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.new(1, 1, 1) -- Cor branca (será sobrescrita se TeamCheck estiver ativo)
    return text
end

--// Função para criar um novo texto de porcentagem de vida
local function NewHealthText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Text = "[100%]"
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.new(1, 1, 1) -- Cor branca (será sobrescrita se TeamCheck estiver ativo)
    return text
end

--// Função para inicializar o ESP para um jogador
local function ESP(player)
    local highlight = NewHighlight()
    local nameText = NewText()
    local healthText = NewHealthText()

    ESPObjects[player] = {highlight = highlight, nameText = nameText, healthText = healthText}

    local function Update()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local pos, vis = Camera:WorldToViewportPoint(head.Position)

                -- Atualizar o realce (sempre ativo, independentemente da visibilidade)
                highlight.Adornee = player.Character
                highlight.Enabled = true

                -- Verificação de equipe
                if Settings.TeamCheck then
                    local team = player.Team
                    if team then
                        -- Usa a cor da equipe do jogador
                        local teamColor = team.TeamColor.Color
                        highlight.FillColor = teamColor
                        highlight.OutlineColor = teamColor
                        nameText.Color = teamColor -- Aplica a cor da equipe ao nome
                        healthText.Color = teamColor -- Aplica a cor da equipe ao texto de vida
                    else
                        -- Se o jogador não estiver em uma equipe, usa a cor padrão
                        highlight.FillColor = Settings.HighlightColor
                        highlight.OutlineColor = Settings.HighlightColor
                        nameText.Color = Settings.HighlightColor -- Aplica a cor padrão ao nome
                        healthText.Color = Settings.HighlightColor -- Aplica a cor padrão ao texto de vida
                    end
                else
                    -- Se o TeamCheck estiver desativado, usa a cor padrão
                    highlight.FillColor = Settings.HighlightColor
                    highlight.OutlineColor = Settings.HighlightColor
                    nameText.Color = Settings.HighlightColor -- Aplica a cor padrão ao nome
                    healthText.Color = Settings.HighlightColor -- Aplica a cor padrão ao texto de vida
                end

                -- Atualizar o nome do jogador
                if Settings.ShowName then
                    nameText.Text = player.Name
                    nameText.Position = Vector2.new(pos.X, pos.Y - 20) -- Posiciona acima da cabeça
                    nameText.Visible = true

                    -- Atualizar a porcentagem de vida
                    if Settings.Healthbar then
                        local health = player.Character.Humanoid.Health
                        local maxHealth = player.Character.Humanoid.MaxHealth
                        local healthRatio = math.floor((health / maxHealth) * 100) -- Calcula a porcentagem de vida
                        healthText.Text = "[" .. healthRatio .. "%]" -- Formata o texto

                        -- Posiciona o texto de vida ao lado do nome
                        healthText.Position = Vector2.new(pos.X + nameText.TextBounds.X + 5, pos.Y - 20)
                        healthText.Visible = true
                    else
                        healthText.Visible = false
                    end
                else
                    nameText.Visible = false
                    healthText.Visible = false
                end
            else
                -- Desativar o realce se o jogador não for válido
                highlight.Enabled = false
                nameText.Visible = false
                healthText.Visible = false
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
        ESPObjects[player].highlight:Destroy() -- Remover o realce
        ESPObjects[player].nameText:Remove() -- Remover o texto do nome
        ESPObjects[player].healthText:Remove() -- Remover o texto de vida
        ESPObjects[player] = nil -- Limpar da tabela
    end
end)
