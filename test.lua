--[[
╔══════════════════════════════════════════════════════════════╗
║                    Zelo Library v2.4.0                       ║
║                  UI Library para Roblox                      ║
╚══════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CARREGAR A LIBRARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/XScommunity/zelo/refs/heads/main/library.lua"
  ))()

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CRIAR JANELA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  local Window = Library:CreateWindow({
      Title      = "Meu Script",
      SubTitle   = "v1.0",
      ToggleKey  = Enum.KeyCode.RightShift,
      Blur       = true,       -- blur no fundo da UI (não do jogo)
      Discord    = "https://discord.gg/exemplo",
      KeySystem  = false,
  })

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ELEMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Tab e Groupbox
  local Tab  = Window:AddTab("Combat")
  local Left = Tab:AddLeftGroupbox("Aimbot")
  local Right= Tab:AddRightGroupbox("Visuals")

  -- Toggle
  local myToggle = Left:AddToggle({
      Text     = "Ativar Aimbot",
      Default  = false,
      Callback = function(v) print("Toggle:", v) end,
  })
  myToggle:Set(true)   -- forçar valor
  myToggle:Get()       -- ler valor

  -- Button
  Left:AddButton({
      Text     = "Teleportar",
      Callback = function() print("clicou!") end,
  })

  -- Slider
  local mySlider = Left:AddSlider({
      Text     = "FOV",
      Min      = 1,
      Max      = 360,
      Default  = 90,
      Callback = function(v) print("Slider:", v) end,
  })
  mySlider:Set(45)
  mySlider:Get()

  -- Dropdown
  local myDrop = Left:AddDropdown({
      Text     = "Time",
      Options  = {"Survivors", "Killers", "Spectators"},
      Default  = "Survivors",
      Callback = function(v) print("Drop:", v) end,
  })
  myDrop:Set("Killers")
  myDrop:Get()
  myDrop:Refresh({"A", "B", "C"})   -- atualiza lista

  -- Input
  local myInput = Left:AddInput({
      Text        = "Jogador",
      Placeholder = "Digite o nome...",
      Default     = "",
      Callback    = function(v) print("Input:", v) end,
  })
  myInput:Set("Player1")
  myInput:Get()

  -- Keybind
  local myKey = Left:AddKeybind({
      Text     = "Ativar com tecla",
      Default  = Enum.KeyCode.E,
      Callback = function(k) print("Key:", k) end,
  })
  myKey:Get()

  -- Paragraph
  local myPara = Right:AddParagraph({
      Title = "Informações",
      Body  = "Este é um parágrafo de texto de exemplo.",
  })
  myPara:SetBody("Novo texto aqui!")

  -- Image  ← NOVO em v2.4.0
  --   Suporta qualquer URL pública: GitHub raw, imgur, etc.
  Right:AddImage({
      Text  = "Logo do Script",      -- label opcional
      URL   = "https://raw.githubusercontent.com/XScommunity/zelo/refs/heads/main/logo.png",
      Size  = 80,                    -- altura em px (padrão 80)
  })

  -- ColorPicker
  local myColor = Right:AddColorPicker({
      Text     = "Cor do ESP",
      Default  = Color3.fromRGB(255, 0, 0),
      Callback = function(c) print("Cor:", c) end,
  })
  myColor:Set(Color3.fromRGB(0, 255, 0))
  myColor:Get()

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  NOTIFICAÇÃO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Library:Notify({
      Title    = "Sucesso",
      Text     = "Script carregado!",
      Duration = 4,
      Type     = "success",   -- "success" | "error" | "info" | "warning"
  })

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")

local LP   = Players.LocalPlayer
local NAME = LP.Name

-- ────────────────────────────────────────────
-- PALETA — tema ultra-escuro v2.4.0
-- ────────────────────────────────────────────
local C = {
    BG        = Color3.fromRGB(8,  8,  10),
    Surface   = Color3.fromRGB(13, 13, 16),
    Surface2  = Color3.fromRGB(18, 18, 22),
    Surface3  = Color3.fromRGB(24, 24, 30),
    Border    = Color3.fromRGB(32, 32, 40),
    Border2   = Color3.fromRGB(44, 44, 55),
    Text      = Color3.fromRGB(210, 210, 220),
    Dim       = Color3.fromRGB(110, 110, 130),
    Muted     = Color3.fromRGB(60,  60,  75),
    White     = Color3.fromRGB(230, 230, 240),
    Black     = Color3.fromRGB(8,   8,  10),
    Green     = Color3.fromRGB(60,  200, 120),
    Red       = Color3.fromRGB(210, 60,  60),
    TabBG     = Color3.fromRGB(220, 220, 232),
    Blue      = Color3.fromRGB(80,  95,  235),
    Accent    = Color3.fromRGB(100, 80,  255),

    NotifySuccess = Color3.fromRGB(60,  190, 100),
    NotifyError   = Color3.fromRGB(230, 60,  60),
    NotifyInfo    = Color3.fromRGB(50,  140, 240),
    NotifyWarning = Color3.fromRGB(240, 150, 30),
}

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ────────────────────────────────────────────
-- HELPERS
-- ────────────────────────────────────────────
local function make(class, props, parent)
    local o = Instance.new(class)
    if class == "Frame" or class == "ScrollingFrame" then
        o.BorderSizePixel = 0
    end
    for k, v in pairs(props) do
        pcall(function() o[k] = v end)
    end
    o.Parent = parent
    return o
end

local function corner(r, p)
    local o = Instance.new("UICorner")
    o.CornerRadius = UDim.new(0, r)
    o.Parent = p
    return o
end

local function stroke(col, t, p)
    local o = Instance.new("UIStroke")
    o.Color = col
    o.Thickness = t
    o.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    o.Parent = p
    return o
end

local function pad(T, B, L, R, p)
    local o = Instance.new("UIPadding")
    o.PaddingTop    = UDim.new(0, T or 0)
    o.PaddingBottom = UDim.new(0, B or 0)
    o.PaddingLeft   = UDim.new(0, L or 0)
    o.PaddingRight  = UDim.new(0, R or 0)
    o.Parent = p
end

local function listLayout(dir, padding, p)
    local o = Instance.new("UIListLayout")
    o.FillDirection = dir or Enum.FillDirection.Vertical
    o.Padding       = UDim.new(0, padding or 0)
    o.SortOrder     = Enum.SortOrder.LayoutOrder
    o.Parent        = p
    return o
end

local function tween(obj, t, props)
    TweenService:Create(obj,
        TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function onActivated(obj, fn)
    if obj:IsA("GuiButton") then
        obj.MouseButton1Click:Connect(fn)
        obj.TouchTap:Connect(fn)
    else
        obj.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                fn(inp)
            end
        end)
    end
end

-- ────────────────────────────────────────────
-- NOTIFICAÇÕES
-- ────────────────────────────────────────────
local NotifyGui = nil
local function getNotifyGui()
    if NotifyGui then return NotifyGui end
    NotifyGui = make("ScreenGui", {
        Name = "ZeloNotify",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)
    pcall(function() NotifyGui.Parent = LP:WaitForChild("PlayerGui") end)
    return NotifyGui
end

-- ────────────────────────────────────────────
-- LIBRARY OBJECT
-- ────────────────────────────────────────────
local Zelo = {}
Zelo.__index = Zelo

function Zelo:Notify(opts)
    opts = opts or {}
    local title      = opts.Title    or "Notificacao"
    local text       = opts.Text     or ""
    local duration   = opts.Duration or 5
    local notifyType = opts.Type     or "info"

    local typeColors = {
        success = C.NotifySuccess,
        error   = C.NotifyError,
        info    = C.NotifyInfo,
        warning = C.NotifyWarning,
    }
    local accentColor = typeColors[notifyType] or C.NotifyInfo

    local gui = getNotifyGui()
    local container = gui:FindFirstChild("NotifyContainer")
    if not container then
        container = make("Frame", {
            Name = "NotifyContainer",
            Size = UDim2.new(0, 320, 1, -40),
            Position = UDim2.new(1, -340, 0, 20),
            BackgroundTransparency = 1,
        }, gui)
        local layout = listLayout(Enum.FillDirection.Vertical, 8, container)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    end

    local notif = make("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = 0.03,
        AutomaticSize = Enum.AutomaticSize.Y,
    }, container)
    corner(8, notif)
    stroke(C.Border, 1, notif)

    local accentBar = make("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        ZIndex = 2,
    }, notif)
    corner(3, accentBar)

    local inner = make("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
    }, notif)
    pad(12, 12, 0, 0, inner)
    listLayout(Enum.FillDirection.Vertical, 4, inner)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, inner)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = C.Dim,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
    }, inner)

    local progressBar = make("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.3,
        ZIndex = 2,
    }, notif)

    notif.Position = UDim2.new(1, 50, 0, 0)
    tween(notif, 0.3, {Position = UDim2.new(0, 0, 0, 0)})
    tween(progressBar, duration, {Size = UDim2.new(0, 0, 0, 2)})

    task.delay(duration, function()
        tween(notif, 0.3, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
        task.delay(0.3, function() notif:Destroy() end)
    end)
end

-- ────────────────────────────────────────────
-- CREATE WINDOW
-- ────────────────────────────────────────────
function Zelo:CreateWindow(cfg)
    cfg = cfg or {}

    local Title        = cfg.Title        or "Zelo"
    local SubTitle     = cfg.SubTitle     or "v1.0"
    local KeySystem    = cfg.KeySystem    or false
    local ValidKey     = cfg.Key          or ""
    local KeyNote      = cfg.KeyNote      or "Insira a key para continuar."
    local GetKeyLink   = cfg.GetKeyLink   or nil
    local SaveKey      = cfg.SaveKey ~= false
    local Discord      = cfg.Discord      or nil
    local DiscordText  = cfg.DiscordText  or "Entre no nosso servidor!"
    local ToggleKey    = cfg.ToggleKey    or Enum.KeyCode.RightShift
    local Transparency = math.clamp(cfg.Transparency or 0.05, 0, 0.9)
    local BlurEnabled  = cfg.Blur ~= false

    local SaveFileName   = cfg.SaveFileName   or ("Zelo_Key_" .. game.PlaceId)
    local KeyTitle       = cfg.KeyTitle       or "Key System"
    local KeySubTitle    = cfg.KeySubTitle    or nil
    local KeyGetText     = cfg.KeyGetText     or "Get Key"
    local KeyConfirmText = cfg.KeyConfirmText or "Confirmar"
    local KeyCloseText   = cfg.KeyCloseText   or "Fechar"

    local WIN_VISIBLE  = false
    local WIN_ALPHA    = Transparency
    local TABS         = {}
    local ACTIVE_TAB   = nil
    local SETTINGS_ACTIVE = false
    local MAIN_GUI     = nil
    local WIN          = nil
    local WindowObj    = nil

    -- ── Backdrop blur (frame escuro atrás da UI, não blur do Lighting) ──
    local BACKDROP = nil

    MAIN_GUI = make("ScreenGui", {
        Name = "ZeloLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)
    pcall(function() MAIN_GUI.Parent = LP:WaitForChild("PlayerGui") end)

    if BlurEnabled then
        BACKDROP = make("Frame", {
            Name = "Backdrop",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex  = 0,
        }, MAIN_GUI)
    end

    local function setBlur(on)
        if not BlurEnabled or not BACKDROP then return end
        if on then
            BACKDROP.Visible = true
            tween(BACKDROP, 0.4, {BackgroundTransparency = 0.55})
        else
            tween(BACKDROP, 0.3, {BackgroundTransparency = 1})
            task.delay(0.3, function()
                if BACKDROP then BACKDROP.Visible = false end
            end)
        end
    end

    local WIN_W    = IS_MOBILE and 580 or 720
    local WIN_H    = IS_MOBILE and 420 or 500
    local WIN_X    = IS_MOBILE and -WIN_W/2 or -360
    local WIN_Y    = IS_MOBILE and -WIN_H/2 or 60
    local WIN_XSCALE = 0.5
    local WIN_YSCALE = IS_MOBILE and 0.5 or 0

    WIN = make("Frame", {
        Name = "Window",
        Size = UDim2.new(0, WIN_W, 0, WIN_H),
        Position = UDim2.new(WIN_XSCALE, WIN_X, WIN_YSCALE, WIN_Y),
        BackgroundColor3 = C.BG,
        BackgroundTransparency = WIN_ALPHA,
        Active = true,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 1,
    }, MAIN_GUI)
    corner(12, WIN)
    stroke(C.Border, 1, WIN)

    -- Header
    local Header = make("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = C.BG,
        BackgroundTransparency = WIN_ALPHA,
        Active = true,
    }, WIN)

    make("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = C.Border,
    }, Header)

    local LogoF = make("Frame", {
        Size = UDim2.new(0, 140, 1, 0),
        BackgroundTransparency = 1,
    }, Header)

    make("TextLabel", {
        Size = UDim2.new(1, -10, 0, 18),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, LogoF)

    make("TextLabel", {
        Size = UDim2.new(1, -10, 0, 12),
        Position = UDim2.new(0, 14, 0, 26),
        BackgroundTransparency = 1,
        Text = SubTitle,
        TextColor3 = C.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, LogoF)

    local UserBtn = make("TextButton", {
        Name = "UserBtn",
        Size = UDim2.new(0, 120, 0, 28),
        Position = UDim2.new(1, -204, 0.5, -14),
        BackgroundTransparency = 1,
        BackgroundColor3 = C.Surface2,
        Text = NAME .. "  ⚙",
        TextColor3 = C.Dim,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
    }, Header)
    corner(6, UserBtn)

    local MinBtn = make("TextButton", {
        Name = "MinBtn",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -76, 0.5, -16),
        BackgroundColor3 = C.Surface2,
        Text = "–",
        TextColor3 = C.Dim,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
    }, Header)
    corner(6, MinBtn)

    MinBtn.MouseEnter:Connect(function()
        tween(MinBtn, 0.15, {BackgroundColor3 = C.Surface3, TextColor3 = C.Text})
    end)
    MinBtn.MouseLeave:Connect(function()
        tween(MinBtn, 0.15, {BackgroundColor3 = C.Surface2, TextColor3 = C.Dim})
    end)

    local CloseBtn = make("TextButton", {
        Name = "CloseBtn",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -40, 0.5, -16),
        BackgroundColor3 = C.Surface2,
        Text = "✕",
        TextColor3 = C.Dim,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
    }, Header)
    corner(6, CloseBtn)

    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, 0.15, {BackgroundColor3 = C.Red, TextColor3 = C.White})
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, 0.15, {BackgroundColor3 = C.Surface2, TextColor3 = C.Dim})
    end)

    -- Drag
    local dragging, dragStart, startPos = false, nil, nil
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = WIN.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            WIN.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Body
    local Body = make("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -46),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, WIN)

    -- Sidebar
    local Sidebar = make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 160, 1, 0),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = WIN_ALPHA,
    }, Body)

    make("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = C.Border,
    }, Sidebar)

    local TabSearch = make("TextBox", {
        Name = "TabSearch",
        Size = UDim2.new(1, -16, 0, 30),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = C.Surface2,
        Text = "",
        PlaceholderText = "Buscar tabs...",
        TextColor3 = C.Text,
        PlaceholderColor3 = C.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        ClearTextOnFocus = false,
    }, Sidebar)
    corner(6, TabSearch)
    stroke(C.Border, 1, TabSearch)
    pad(0, 0, 8, 8, TabSearch)

    local TabScroll = make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
    }, Sidebar)
    listLayout(Enum.FillDirection.Vertical, 2, TabScroll)
    pad(6, 6, 6, 6, TabScroll)

    local ContentArea = make("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 160, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, Body)

    -- ── SETTINGS PANEL ──────────────────────────────
    local SettingsFrame = make("Frame", {
        Name = "SettingsFrame",
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 160, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Visible = false,
    }, Body)

    local SettingsScroll = make("ScrollingFrame", {
        Size = UDim2.new(1, -28, 1, -10),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
    }, SettingsFrame)
    listLayout(Enum.FillDirection.Vertical, 10, SettingsScroll)

    local function makeSettingsSection(title)
        local gb = make("Frame", {
            Name = "SettingsGroup",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = C.Surface,
            AutomaticSize = Enum.AutomaticSize.Y,
        }, SettingsScroll)
        corner(8, gb)
        stroke(C.Border, 1, gb)

        local inner = make("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
        }, gb)
        pad(10, 10, 12, 12, inner)
        listLayout(Enum.FillDirection.Vertical, 6, inner)

        if title and title ~= "" then
            local hdr = make("Frame", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                LayoutOrder = 0,
            }, inner)
            make("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = title:upper(),
                TextColor3 = C.Muted,
                Font = Enum.Font.GothamBold,
                TextSize = 8,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, hdr)
            make("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = C.Border,
            }, hdr)
        end
        return inner
    end

    local secHub = makeSettingsSection("Hub")
    local loCount = 1

    -- No Name toggle
    local noNameVal = false
    local noNameRow = make("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C.Surface2,
        LayoutOrder = loCount,
    }, secHub)
    loCount += 1
    corner(6, noNameRow)
    stroke(C.Border, 1, noNameRow)

    make("TextLabel", {
        Size = UDim2.new(1, -54, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "No Name",
        TextColor3 = C.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, noNameRow)

    local noNamePill = make("Frame", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = C.Surface3,
    }, noNameRow)
    corner(9, noNamePill)
    stroke(C.Border, 1, noNamePill)

    local noNameKnob = make("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = C.White,
    }, noNamePill)
    corner(6, noNameKnob)

    local function setNoName(v)
        noNameVal = v
        tween(noNamePill, 0.15, {BackgroundColor3 = v and C.Green or C.Surface3})
        tween(noNameKnob, 0.15, {
            Position = v and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        })
        UserBtn.Text = v and "⚙" or (NAME .. "  ⚙")
    end
    onActivated(noNameRow, function() setNoName(not noNameVal) end)

    -- Keybind row
    local kbRow = make("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = loCount,
    }, secHub)
    loCount += 1

    local kbBg = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.Surface2,
    }, kbRow)
    corner(6, kbBg)
    stroke(C.Border, 1, kbBg)

    make("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Keybind (esconder)",
        TextColor3 = C.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, kbBg)

    local kbBox = make("TextButton", {
        Size = UDim2.new(0, 80, 0, 22),
        Position = UDim2.new(1, -90, 0.5, -11),
        BackgroundColor3 = C.Surface3,
        Text = "[" .. tostring(ToggleKey):gsub("Enum.KeyCode.", "") .. "]",
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        AutoButtonColor = false,
    }, kbBg)
    corner(5, kbBox)
    stroke(C.Border, 1, kbBox)

    local listeningKB = false
    onActivated(kbBox, function()
        listeningKB = true
        kbBox.Text = "[ ... ]"
        kbBox.TextColor3 = C.Muted
    end)
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if listeningKB and inp.UserInputType == Enum.UserInputType.Keyboard then
            ToggleKey = inp.KeyCode
            kbBox.Text = "[" .. tostring(inp.KeyCode):gsub("Enum.KeyCode.", "") .. "]"
            kbBox.TextColor3 = C.Text
            listeningKB = false
        end
    end)

    -- Transparency slider
    local alphaSection = makeSettingsSection("Transparencia")
    local alphaRow = make("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, alphaSection)

    local sliderBG = make("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 16),
        BackgroundColor3 = C.Surface3,
    }, alphaRow)
    corner(3, sliderBG)
    stroke(C.Border2, 1, sliderBG)

    local sliderFill = make("Frame", {
        Size = UDim2.new(WIN_ALPHA, 0, 1, 0),
        BackgroundColor3 = C.Accent,
    }, sliderBG)
    corner(3, sliderFill)

    local alphaLbl = make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Text = math.floor(WIN_ALPHA * 100) .. "%",
        TextColor3 = C.Dim,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, alphaRow)

    local draggingAlpha = false
    sliderBG.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            draggingAlpha = true
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            draggingAlpha = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if draggingAlpha then
            local mx  = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mx - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            WIN_ALPHA = rel
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
            alphaLbl.Text = math.floor(rel * 100) .. "%"
            WIN.BackgroundTransparency    = rel
            Header.BackgroundTransparency = rel
            Sidebar.BackgroundTransparency = rel
        end
    end)

    -- Blur toggle (controls the backdrop frame)
    if BlurEnabled then
        local blurSection = makeSettingsSection("Blur do Fundo")
        local blurRow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
        }, blurSection)

        local blurBg = make("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = C.Surface2,
        }, blurRow)
        corner(6, blurBg)
        stroke(C.Border, 1, blurBg)

        make("TextLabel", {
            Size = UDim2.new(1, -54, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = "Blur ativo",
            TextColor3 = C.Text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, blurBg)

        local blurOn = true
        local blurPill = make("Frame", {
            Size = UDim2.new(0, 36, 0, 18),
            Position = UDim2.new(1, -46, 0.5, -9),
            BackgroundColor3 = C.Green,
        }, blurBg)
        corner(9, blurPill)
        stroke(C.Border, 1, blurPill)

        local blurKnob = make("Frame", {
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(1, -15, 0.5, -6),
            BackgroundColor3 = C.White,
        }, blurPill)
        corner(6, blurKnob)

        onActivated(blurBg, function()
            blurOn = not blurOn
            tween(blurPill, 0.15, {BackgroundColor3 = blurOn and C.Green or C.Surface3})
            tween(blurKnob, 0.15, {
                Position = blurOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            })
            if BACKDROP then
                if blurOn and WIN_VISIBLE then
                    BACKDROP.Visible = true
                    tween(BACKDROP, 0.4, {BackgroundTransparency = 0.55})
                else
                    tween(BACKDROP, 0.3, {BackgroundTransparency = 1})
                    task.delay(0.3, function()
                        if BACKDROP then BACKDROP.Visible = false end
                    end)
                end
            end
        end)
    end

    -- Discord
    if Discord then
        local dcSection = makeSettingsSection("Discord")
        local dcRow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
        }, dcSection)

        local dcBtn = make("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = C.Blue,
            Text = "Copiar invite",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            AutoButtonColor = false,
        }, dcRow)
        corner(6, dcBtn)

        onActivated(dcBtn, function()
            pcall(function() setclipboard(Discord) end)
            dcBtn.Text = "Copiado!"
            task.delay(1.5, function() dcBtn.Text = "Copiar invite" end)
        end)
    end

    -- Unload
    local unloadSection = makeSettingsSection("Unload")
    local unloadRow = make("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, unloadSection)

    local unloadBtn = make("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.Red,
        Text = "Descarregar Script",
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
    }, unloadRow)
    corner(6, unloadBtn)

    onActivated(unloadBtn, function()
        tween(WIN, 0.2, {Size = UDim2.new(0, WIN_W, 0, 0)})
        task.delay(0.25, function()
            if BACKDROP then BACKDROP:Destroy() end
            MAIN_GUI:Destroy()
        end)
    end)

    -- Show / Hide helpers
    local bodyMinimized = false

    local function showWindow()
        WIN.Visible     = true
        Body.Visible    = true
        WIN_VISIBLE     = true
        bodyMinimized   = false
        tween(WIN, 0.2, {Size = UDim2.new(0, WIN_W, 0, WIN_H)})
    end

    local function hideWindow()
        bodyMinimized = true
        WIN_VISIBLE   = false
        tween(WIN, 0.2, {Size = UDim2.new(0, WIN_W, 0, 46)})
        task.delay(0.2, function() Body.Visible = false end)
    end

    MinBtn.MouseButton1Click:Connect(function()
        if bodyMinimized then showWindow() else hideWindow() end
    end)
    MinBtn.TouchTap:Connect(function()
        if bodyMinimized then showWindow() else hideWindow() end
    end)

    local function closeWin()
        tween(WIN, 0.2, {Size = UDim2.new(0, WIN_W, 0, 0)})
        setBlur(false)
        task.delay(0.2, function()
            WIN.Visible   = false
            Body.Visible  = true
            WIN_VISIBLE   = false
            bodyMinimized = false
        end)
    end

    CloseBtn.MouseButton1Click:Connect(closeWin)
    CloseBtn.TouchTap:Connect(closeWin)

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == ToggleKey and not listeningKB then
            if not WIN.Visible then
                WIN.Size    = UDim2.new(0, WIN_W, 0, 0)
                WIN.Visible = true
                Body.Visible = true
                WIN_VISIBLE  = true
                bodyMinimized = false
                tween(WIN, 0.2, {Size = UDim2.new(0, WIN_W, 0, WIN_H)})
                setBlur(true)
            elseif bodyMinimized then
                showWindow()
            else
                hideWindow()
            end
        end
    end)

    TabSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local q = TabSearch.Text:lower()
        for _, btn in pairs(TabScroll:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Visible = q == "" or btn.Text:lower():find(q, 1, true) ~= nil
            end
        end
    end)

    local function openSettings()
        SETTINGS_ACTIVE = true
        if ACTIVE_TAB then
            ACTIVE_TAB.Frame.Visible = false
            ACTIVE_TAB.SectionSearch.Visible = false
            ACTIVE_TAB.Btn.BackgroundColor3 = C.Surface2
            ACTIVE_TAB.Btn.TextColor3       = C.Dim
        end
        SettingsFrame.Visible           = true
        UserBtn.BackgroundColor3        = C.TabBG
        UserBtn.TextColor3              = C.Black
        UserBtn.BackgroundTransparency  = 0
    end

    local function closeSettings()
        SETTINGS_ACTIVE               = false
        SettingsFrame.Visible         = false
        UserBtn.BackgroundColor3      = C.Surface2
        UserBtn.TextColor3            = C.Dim
        UserBtn.BackgroundTransparency = 1
        if ACTIVE_TAB then
            ACTIVE_TAB.Frame.Visible         = true
            ACTIVE_TAB.SectionSearch.Visible = true
            ACTIVE_TAB.Btn.BackgroundColor3  = C.TabBG
            ACTIVE_TAB.Btn.TextColor3        = C.Black
        end
    end

    UserBtn.MouseEnter:Connect(function()
        if not SETTINGS_ACTIVE then
            UserBtn.BackgroundTransparency = 0
            UserBtn.TextColor3 = C.Text
        end
    end)
    UserBtn.MouseLeave:Connect(function()
        if not SETTINGS_ACTIVE then
            UserBtn.BackgroundTransparency = 1
            UserBtn.TextColor3 = C.Dim
        end
    end)
    onActivated(UserBtn, function()
        if SETTINGS_ACTIVE then closeSettings() else openSettings() end
    end)

    WindowObj = {}

    local function selectTab(tabObj)
        if SETTINGS_ACTIVE then closeSettings() end
        if ACTIVE_TAB then
            ACTIVE_TAB.Btn.BackgroundColor3  = C.Surface2
            ACTIVE_TAB.Btn.TextColor3        = C.Dim
            ACTIVE_TAB.Frame.Visible         = false
            ACTIVE_TAB.SectionSearch.Visible = false
        end
        ACTIVE_TAB = tabObj
        tabObj.Btn.BackgroundColor3  = C.TabBG
        tabObj.Btn.TextColor3        = C.Black
        tabObj.Frame.Visible         = true
        tabObj.SectionSearch.Visible = true
    end

    function WindowObj:AddTab(name)
        local tabBtn = make("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = C.Surface2,
            Text = name,
            TextColor3 = C.Dim,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            AutoButtonColor = false,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, TabScroll)
        corner(6, tabBtn)
        pad(0, 0, 10, 0, tabBtn)

        local tabFrame = make("Frame", {
            Name = "Tab_" .. name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ClipsDescendants = true,
        }, ContentArea)

        local secSearch = make("TextBox", {
            Name = "SecSearch",
            Size = UDim2.new(1, -28, 0, 28),
            Position = UDim2.new(0, 14, 0, 10),
            BackgroundColor3 = C.Surface2,
            Text = "",
            PlaceholderText = "Buscar secoes...",
            TextColor3 = C.Text,
            PlaceholderColor3 = C.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            ClearTextOnFocus = false,
            Visible = false,
        }, tabFrame)
        corner(6, secSearch)
        stroke(C.Border, 1, secSearch)
        pad(0, 0, 8, 8, secSearch)

        local columnsScroll = make("ScrollingFrame", {
            Name = "ColumnsScroll",
            Size = UDim2.new(1, -14, 1, -48),
            Position = UDim2.new(0, 14, 0, 44),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = C.Border2,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ElasticBehavior = Enum.ElasticBehavior.Never,
            ClipsDescendants = true,
        }, tabFrame)

        local columnsRow = make("Frame", {
            Name = "ColumnsRow",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
        }, columnsScroll)

        local leftContainer = make("Frame", {
            Name = "LeftContainer",
            Size = UDim2.new(0.5, -5, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            ClipsDescendants = false,
        }, columnsRow)
        listLayout(Enum.FillDirection.Vertical, 10, leftContainer)
        pad(0, 8, 0, 4, leftContainer)

        local rightContainer = make("Frame", {
            Name = "RightContainer",
            Size = UDim2.new(0.5, -5, 0, 0),
            Position = UDim2.new(0.5, 5, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            ClipsDescendants = false,
        }, columnsRow)
        listLayout(Enum.FillDirection.Vertical, 10, rightContainer)
        pad(0, 8, 4, 0, rightContainer)

        secSearch:GetPropertyChangedSignal("Text"):Connect(function()
            local q = secSearch.Text:lower()
            for _, child in pairs(leftContainer:GetChildren()) do
                if child:IsA("Frame") and child.Name == "Groupbox" then
                    local title = child:GetAttribute("Title") or ""
                    child.Visible = q == "" or title:lower():find(q, 1, true) ~= nil
                end
            end
            for _, child in pairs(rightContainer:GetChildren()) do
                if child:IsA("Frame") and child.Name == "Groupbox" then
                    local title = child:GetAttribute("Title") or ""
                    child.Visible = q == "" or title:lower():find(q, 1, true) ~= nil
                end
            end
        end)

        local tabObj = {
            Btn            = tabBtn,
            Frame          = tabFrame,
            SectionSearch  = secSearch,
            LeftContainer  = leftContainer,
            RightContainer = rightContainer,
            ColumnsScroll  = columnsScroll,
        }
        table.insert(TABS, tabObj)

        tabBtn.MouseEnter:Connect(function()
            if ACTIVE_TAB ~= tabObj then
                tabBtn.BackgroundColor3 = C.Surface3
                tabBtn.TextColor3       = C.Text
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if ACTIVE_TAB ~= tabObj then
                tabBtn.BackgroundColor3 = C.Surface2
                tabBtn.TextColor3       = C.Dim
            end
        end)
        onActivated(tabBtn, function() selectTab(tabObj) end)

        if #TABS == 1 then selectTab(tabObj) end

        local TabObj = {}

        local function createGroupbox(sTitle, isRight)
            local container = isRight and rightContainer or leftContainer

            local gbFrame = make("Frame", {
                Name = "Groupbox",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = C.Surface,
                BackgroundTransparency = WIN_ALPHA,
                AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
            }, container)
            gbFrame:SetAttribute("Title", sTitle or "")
            corner(8, gbFrame)
            stroke(C.Border, 1, gbFrame)

            local gbInner = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
            }, gbFrame)
            pad(10, 10, 12, 12, gbInner)
            listLayout(Enum.FillDirection.Vertical, 6, gbInner)

            if sTitle and sTitle ~= "" then
                local hdrRow = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    LayoutOrder = 0,
                }, gbInner)

                make("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = sTitle:upper(),
                    TextColor3 = C.Muted,
                    Font = Enum.Font.GothamBold,
                    TextSize = 8,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, hdrRow)

                make("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = C.Border,
                }, hdrRow)
            end

            return gbFrame, gbInner
        end

        function TabObj:AddLeftGroupbox(sTitle)
            local gbFrame, gbInner = createGroupbox(sTitle, false)
            return self:_createSectionObj(gbInner, gbFrame)
        end

        function TabObj:AddRightGroupbox(sTitle)
            local gbFrame, gbInner = createGroupbox(sTitle, true)
            return self:_createSectionObj(gbInner, gbFrame)
        end

        function TabObj:_createSectionObj(secInner, gbFrame)
            local SectionObj = {}
            local orderCount = 1

            local function nextOrder()
                orderCount += 1
                return orderCount
            end

            local function makeRow(h)
                return make("Frame", {
                    Size = UDim2.new(1, 0, 0, h or 32),
                    BackgroundTransparency = 1,
                    LayoutOrder = nextOrder(),
                    ClipsDescendants = false,
                }, secInner)
            end

            -- ── Button ──────────────────────────────────────
            function SectionObj:AddButton(opts)
                opts = opts or {}
                local row = makeRow(32)
                local b = make("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                    Text = opts.Text or "Button",
                    TextColor3 = C.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    AutoButtonColor = false,
                }, row)
                corner(6, b)
                stroke(C.Border, 1, b)

                b.MouseEnter:Connect(function()
                    tween(b, 0.12, {BackgroundColor3 = C.Surface3})
                end)
                b.MouseLeave:Connect(function()
                    tween(b, 0.12, {BackgroundColor3 = C.Surface2})
                end)
                onActivated(b, function()
                    tween(b, 0.06, {BackgroundColor3 = C.Border})
                    task.delay(0.1, function()
                        tween(b, 0.1, {BackgroundColor3 = C.Surface2})
                    end)
                    if opts.Callback then opts.Callback() end
                end)
                return b
            end

            -- ── Toggle ──────────────────────────────────────
            function SectionObj:AddToggle(opts)
                opts = opts or {}
                local val = opts.Default or false
                local row = makeRow(32)
                local bg  = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size = UDim2.new(1, -54, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or "Toggle",
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, bg)

                local pill = make("Frame", {
                    Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -46, 0.5, -9),
                    BackgroundColor3 = val and C.Green or C.Surface3,
                }, bg)
                corner(9, pill)
                stroke(C.Border, 1, pill)

                local knob = make("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = val and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
                    BackgroundColor3 = C.White,
                }, pill)
                corner(6, knob)

                local function setToggle(v)
                    val = v
                    tween(pill, 0.15, {BackgroundColor3 = v and C.Green or C.Surface3})
                    tween(knob, 0.15, {
                        Position = v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
                    })
                    if opts.Callback then opts.Callback(v) end
                end

                onActivated(bg, function() setToggle(not val) end)

                local ctrl = {}
                function ctrl:Set(v) setToggle(v) end
                function ctrl:Get() return val end
                return ctrl
            end

            -- ── Keybind ─────────────────────────────────────
            function SectionObj:AddKeybind(opts)
                opts = opts or {}
                local currentKey = opts.Default or Enum.KeyCode.Unknown
                local listening  = false
                local row = makeRow(32)
                local bg  = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or "Keybind",
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, bg)

                local keyBtn = make("TextButton", {
                    Size = UDim2.new(0, 80, 0, 22),
                    Position = UDim2.new(1, -90, 0.5, -11),
                    BackgroundColor3 = C.Surface3,
                    Text = "[" .. tostring(currentKey):gsub("Enum.KeyCode.", "") .. "]",
                    TextColor3 = C.Dim,
                    Font = Enum.Font.GothamBold,
                    TextSize = 9,
                    AutoButtonColor = false,
                }, bg)
                corner(5, keyBtn)
                stroke(C.Border, 1, keyBtn)

                onActivated(keyBtn, function()
                    listening = true
                    keyBtn.Text = "[ ... ]"
                    keyBtn.TextColor3 = C.Muted
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if gp then return end
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = inp.KeyCode
                        keyBtn.Text = "[" .. tostring(inp.KeyCode):gsub("Enum.KeyCode.", "") .. "]"
                        keyBtn.TextColor3 = C.Dim
                        listening = false
                        if opts.Callback then opts.Callback(currentKey) end
                    end
                end)

                local ctrl = {}
                function ctrl:Get() return currentKey end
                return ctrl
            end

            -- ── Input ───────────────────────────────────────
            function SectionObj:AddInput(opts)
                opts = opts or {}
                local row = makeRow(32)
                local bg  = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or "Input",
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, bg)

                local box = make("TextBox", {
                    Size = UDim2.new(0.5, -10, 0, 22),
                    Position = UDim2.new(0.5, 0, 0.5, -11),
                    BackgroundColor3 = C.Surface3,
                    Text = opts.Default or "",
                    PlaceholderText = opts.Placeholder or "...",
                    TextColor3 = C.Text,
                    PlaceholderColor3 = C.Muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    ClearTextOnFocus = true,
                }, bg)
                corner(5, box)
                stroke(C.Border, 1, box)
                pad(0, 0, 8, 8, box)

                box.FocusLost:Connect(function()
                    if opts.Callback then opts.Callback(box.Text) end
                end)

                local ctrl = {}
                function ctrl:Get() return box.Text end
                function ctrl:Set(v) box.Text = tostring(v) end
                return ctrl
            end

            -- ── Paragraph ───────────────────────────────────
            function SectionObj:AddParagraph(opts)
                opts = opts or {}
                local row = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = C.Surface2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = nextOrder(),
                }, secInner)
                corner(6, row)
                stroke(C.Border, 1, row)
                pad(8, 8, 10, 10, row)

                local inner = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                }, row)
                listLayout(Enum.FillDirection.Vertical, 4, inner)

                if opts.Title and opts.Title ~= "" then
                    make("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Text = opts.Title,
                        TextColor3 = C.White,
                        Font = Enum.Font.GothamBold,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }, inner)
                end

                local bodyLbl = make("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Body or "",
                    TextColor3 = C.Dim,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                }, inner)

                local ctrl = {}
                function ctrl:SetBody(v) bodyLbl.Text = tostring(v) end
                return ctrl
            end

            -- ── Image ← NOVO ────────────────────────────────
            --   Aceita qualquer URL pública (GitHub raw, imgur, etc.)
            --   Usa Image = URL na ImageLabel — funciona em exploits que
            --   permitem HTTP images (ex: Synapse X / KRNL com setRobloxGui).
            --   Se o executor não suportar URLs externas, a imagem ficará em
            --   branco mas a row ainda renderiza corretamente.
            function SectionObj:AddImage(opts)
                opts = opts or {}
                local imgSize = opts.Size or 80
                local url     = opts.URL  or ""

                local row = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = C.Surface2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = nextOrder(),
                    ClipsDescendants = false,
                }, secInner)
                corner(6, row)
                stroke(C.Border, 1, row)
                pad(8, 8, 10, 10, row)

                local inner = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                }, row)
                listLayout(Enum.FillDirection.Vertical, 6, inner)

                if opts.Text and opts.Text ~= "" then
                    make("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Text = opts.Text,
                        TextColor3 = C.Dim,
                        Font = Enum.Font.GothamBold,
                        TextSize = 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }, inner)
                end

                -- Wrapper para manter aspect ratio e centralizar
                local imgWrapper = make("Frame", {
                    Size = UDim2.new(1, 0, 0, imgSize),
                    BackgroundColor3 = C.Surface3,
                }, inner)
                corner(6, imgWrapper)
                stroke(C.Border, 1, imgWrapper)

                local imgLabel = make("ImageLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = url,
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0,
                }, imgWrapper)
                corner(6, imgLabel)

                -- Fallback: se URL vazia mostra placeholder
                if url == "" then
                    make("TextLabel", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "sem imagem",
                        TextColor3 = C.Muted,
                        Font = Enum.Font.Gotham,
                        TextSize = 9,
                        TextXAlignment = Enum.TextXAlignment.Center,
                    }, imgWrapper)
                end

                local ctrl = {}
                function ctrl:SetURL(newURL)
                    imgLabel.Image = newURL
                end
                function ctrl:SetSize(newH)
                    imgWrapper.Size = UDim2.new(1, 0, 0, newH)
                end
                return ctrl
            end

            -- ── Dropdown (redesenhado) ───────────────────────
            --   Visual renovado: pill compacta com chevron animado,
            --   lista flutuante com highlight de seleção accent-colored.
            function SectionObj:AddDropdown(opts)
                opts = opts or {}
                local options  = opts.Options or {}
                local selected = opts.Default or (options[1] or "")
                local DROP_MAX_H = 160

                local row = makeRow(34)
                row.ClipsDescendants = false

                local bg = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                    ClipsDescendants = false,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size = UDim2.new(1, -130, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or "Dropdown",
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, bg)

                -- Pill estilizada (label + chevron)
                local pillBtn = make("TextButton", {
                    Size = UDim2.new(0, 110, 0, 24),
                    Position = UDim2.new(1, -118, 0.5, -12),
                    BackgroundColor3 = C.Surface3,
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = false,
                }, bg)
                corner(6, pillBtn)
                stroke(C.Border2, 1, pillBtn)

                local pillLabel = make("TextLabel", {
                    Size = UDim2.new(1, -22, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text = selected,
                    TextColor3 = C.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                }, pillBtn)

                local pillChevron = make("TextLabel", {
                    Size = UDim2.new(0, 18, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▾",
                    TextColor3 = C.Dim,
                    Font = Enum.Font.GothamBold,
                    TextSize = 10,
                }, pillBtn)

                -- Floating list panel
                local dropWrapper = make("Frame", {
                    Size = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = C.Surface,
                    Visible = false,
                    ZIndex = 200,
                    ClipsDescendants = true,
                }, WIN)
                corner(8, dropWrapper)
                stroke(C.Border2, 1, dropWrapper)

                local dropScroll = make("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = C.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ElasticBehavior = Enum.ElasticBehavior.Never,
                    ZIndex = 201,
                }, dropWrapper)
                listLayout(Enum.FillDirection.Vertical, 2, dropScroll)
                pad(4, 4, 4, 4, dropScroll)

                local open = false

                local function refreshOptions()
                    for _, child in pairs(dropScroll:GetChildren()) do
                        if child:IsA("TextButton") or child:IsA("Frame") then
                            child:Destroy()
                        end
                    end
                    for _, opt in pairs(options) do
                        local isSelected = (opt == selected)
                        local optBtn = make("TextButton", {
                            Size = UDim2.new(1, 0, 0, 26),
                            BackgroundColor3 = isSelected and C.Accent or Color3.fromRGB(0,0,0),
                            BackgroundTransparency = isSelected and 0.3 or 1,
                            Text = opt,
                            TextColor3 = isSelected and C.White or C.Text,
                            Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
                            TextSize = 10,
                            AutoButtonColor = false,
                            ZIndex = 202,
                            TextXAlignment = Enum.TextXAlignment.Left,
                        }, dropScroll)
                        corner(5, optBtn)
                        pad(0, 0, 8, 4, optBtn)

                        optBtn.MouseEnter:Connect(function()
                            if opt ~= selected then
                                tween(optBtn, 0.1, {BackgroundTransparency = 0.85})
                                optBtn.BackgroundColor3 = C.Accent
                            end
                        end)
                        optBtn.MouseLeave:Connect(function()
                            if opt ~= selected then
                                tween(optBtn, 0.1, {BackgroundTransparency = 1})
                            end
                        end)
                        onActivated(optBtn, function()
                            selected = opt
                            pillLabel.Text = selected
                            open = false
                            tween(dropWrapper, 0.12, {Size = UDim2.new(0, 110, 0, 0)})
                            task.delay(0.12, function()
                                dropWrapper.Visible = false
                            end)
                            pillChevron.Text = "▾"
                            tween(pillBtn, 0.12, {BackgroundColor3 = C.Surface3})
                            if opts.Callback then opts.Callback(selected) end
                        end)
                    end
                end
                refreshOptions()

                local function repositionDrop()
                    local winPos  = WIN.AbsolutePosition
                    local btnPos  = pillBtn.AbsolutePosition
                    local btnSize = pillBtn.AbsoluteSize

                    local itemCount = 0
                    for _, child in pairs(dropScroll:GetChildren()) do
                        if child:IsA("TextButton") then itemCount += 1 end
                    end
                    local totalH = itemCount * 28 + 8
                    local wrapH  = math.min(totalH, DROP_MAX_H)

                    local relX = btnPos.X - winPos.X
                    local relY = btnPos.Y - winPos.Y + btnSize.Y + 4

                    local winH = WIN.AbsoluteSize.Y
                    if relY + wrapH > winH - 8 then
                        relY = btnPos.Y - winPos.Y - wrapH - 4
                    end

                    dropWrapper.Position = UDim2.new(0, relX, 0, relY)
                    dropWrapper.Size     = UDim2.new(0, btnSize.X, 0, 0)
                    dropWrapper.Visible  = true
                    tween(dropWrapper, 0.15, {Size = UDim2.new(0, btnSize.X, 0, wrapH)})
                end

                onActivated(pillBtn, function()
                    open = not open
                    pillChevron.Text = open and "▴" or "▾"
                    if open then
                        refreshOptions()
                        repositionDrop()
                        tween(pillBtn, 0.12, {BackgroundColor3 = C.Surface2})
                    else
                        tween(dropWrapper, 0.12, {Size = UDim2.new(0, pillBtn.AbsoluteSize.X, 0, 0)})
                        task.delay(0.12, function() dropWrapper.Visible = false end)
                        tween(pillBtn, 0.12, {BackgroundColor3 = C.Surface3})
                    end
                end)

                local ctrl = {}
                function ctrl:Set(v)
                    selected = v
                    pillLabel.Text = selected
                    if opts.Callback then opts.Callback(selected) end
                end
                function ctrl:Get() return selected end
                function ctrl:Refresh(newOpts)
                    options = newOpts
                    refreshOptions()
                end
                return ctrl
            end

            -- ── Slider ──────────────────────────────────────
            function SectionObj:AddSlider(opts)
                opts = opts or {}
                local min = opts.Min     or 0
                local max = opts.Max     or 100
                local val = opts.Default or min
                local row = makeRow(40)
                local bg  = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size = UDim2.new(0.5, 0, 0, 14),
                    Position = UDim2.new(0, 10, 0, 4),
                    BackgroundTransparency = 1,
                    Text = opts.Text or "Slider",
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, bg)

                local valLbl = make("TextLabel", {
                    Size = UDim2.new(0.5, 0, 0, 14),
                    Position = UDim2.new(0.5, -10, 0, 4),
                    BackgroundTransparency = 1,
                    Text = tostring(val),
                    TextColor3 = C.Dim,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Right,
                }, bg)

                local sliderBG2 = make("Frame", {
                    Size = UDim2.new(1, -20, 0, 5),
                    Position = UDim2.new(0, 10, 0, 26),
                    BackgroundColor3 = C.Surface3,
                }, bg)
                corner(3, sliderBG2)
                stroke(C.Border2, 1, sliderBG2)

                local sliderFill2 = make("Frame", {
                    Size = UDim2.new((val - min)/(max - min), 0, 1, 0),
                    BackgroundColor3 = C.Accent,
                }, sliderBG2)
                corner(3, sliderFill2)

                local sliderKnob = make("Frame", {
                    Size = UDim2.new(0, 11, 0, 11),
                    Position = UDim2.new((val - min)/(max - min), -5, 0.5, -5),
                    BackgroundColor3 = C.White,
                    ZIndex = 2,
                }, sliderBG2)
                corner(6, sliderKnob)

                local draggingSlider = false
                local function setSlider(newVal)
                    val = math.clamp(newVal, min, max)
                    local percent = (val - min) / (max - min)
                    sliderFill2.Size      = UDim2.new(percent, 0, 1, 0)
                    sliderKnob.Position   = UDim2.new(percent, -5, 0.5, -5)
                    valLbl.Text           = tostring(math.floor(val * 100) / 100)
                    if opts.Callback then opts.Callback(val) end
                end

                sliderBG2.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = false
                    end
                end)
                RunService.RenderStepped:Connect(function()
                    if draggingSlider then
                        local mx   = UserInputService:GetMouseLocation().X
                        local relX = math.clamp((mx - sliderBG2.AbsolutePosition.X) / sliderBG2.AbsoluteSize.X, 0, 1)
                        setSlider(min + relX * (max - min))
                    end
                end)

                local ctrl = {}
                function ctrl:Set(v) setSlider(v) end
                function ctrl:Get() return val end
                return ctrl
            end

            -- ── ColorPicker ─────────────────────────────────
            function SectionObj:AddColorPicker(opts)
                opts = opts or {}
                local color = opts.Default or Color3.fromRGB(255, 255, 255)
                local row = makeRow(32)
                row.ClipsDescendants = false

                local bg = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = C.Surface2,
                    ClipsDescendants = false,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opts.Text or "Color",
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, bg)

                local colorPreview = make("Frame", {
                    Size = UDim2.new(0, 28, 0, 22),
                    Position = UDim2.new(1, -38, 0.5, -11),
                    BackgroundColor3 = color,
                    ClipsDescendants = false,
                }, bg)
                corner(4, colorPreview)
                stroke(C.Border, 1, colorPreview)

                local pickerOpen  = false
                local pickerFrame = make("Frame", {
                    Size = UDim2.new(0, 180, 0, 120),
                    BackgroundColor3 = C.Surface,
                    Visible = false,
                    ZIndex  = 200,
                }, WIN)
                corner(8, pickerFrame)
                stroke(C.Border, 1, pickerFrame)

                local rInput = make("TextBox", {
                    Size = UDim2.new(0.3, -4, 0, 24),
                    Position = UDim2.new(0, 4, 0, 4),
                    BackgroundColor3 = C.Surface2,
                    Text = tostring(math.floor(color.R * 255)),
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    ZIndex = 201,
                }, pickerFrame)
                corner(4, rInput)

                local gInput = make("TextBox", {
                    Size = UDim2.new(0.3, -4, 0, 24),
                    Position = UDim2.new(0.35, 0, 0, 4),
                    BackgroundColor3 = C.Surface2,
                    Text = tostring(math.floor(color.G * 255)),
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    ZIndex = 201,
                }, pickerFrame)
                corner(4, gInput)

                local bInput = make("TextBox", {
                    Size = UDim2.new(0.3, -4, 0, 24),
                    Position = UDim2.new(0.7, 0, 0, 4),
                    BackgroundColor3 = C.Surface2,
                    Text = tostring(math.floor(color.B * 255)),
                    TextColor3 = C.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    ZIndex = 201,
                }, pickerFrame)
                corner(4, bInput)

                local xOffsets = {0, 0.35, 0.7}
                for i, lbl in ipairs({"R", "G", "B"}) do
                    make("TextLabel", {
                        Size = UDim2.new(0.3, -4, 0, 14),
                        Position = UDim2.new(xOffsets[i], 4, 0, 30),
                        BackgroundTransparency = 1,
                        Text = lbl,
                        TextColor3 = C.Muted,
                        Font = Enum.Font.GothamBold,
                        TextSize = 9,
                        ZIndex = 201,
                    }, pickerFrame)
                end

                local pickerPreview = make("Frame", {
                    Size = UDim2.new(1, -8, 0, 40),
                    Position = UDim2.new(0, 4, 0, 50),
                    BackgroundColor3 = color,
                    ZIndex = 201,
                }, pickerFrame)
                corner(6, pickerPreview)

                local function updateColor()
                    local r = math.clamp(tonumber(rInput.Text) or 0, 0, 255)
                    local g = math.clamp(tonumber(gInput.Text) or 0, 0, 255)
                    local b = math.clamp(tonumber(bInput.Text) or 0, 0, 255)
                    color = Color3.fromRGB(r, g, b)
                    colorPreview.BackgroundColor3 = color
                    pickerPreview.BackgroundColor3 = color
                    if opts.Callback then opts.Callback(color) end
                end

                rInput.FocusLost:Connect(updateColor)
                gInput.FocusLost:Connect(updateColor)
                bInput.FocusLost:Connect(updateColor)

                local function repositionPicker()
                    local winPos     = WIN.AbsolutePosition
                    local previewPos = colorPreview.AbsolutePosition
                    local previewSz  = colorPreview.AbsoluteSize
                    local relX = previewPos.X - winPos.X - 180 + previewSz.X
                    local relY = previewPos.Y - winPos.Y + previewSz.Y + 4
                    pickerFrame.Position = UDim2.new(0, relX, 0, relY)
                end

                onActivated(colorPreview, function()
                    pickerOpen = not pickerOpen
                    if pickerOpen then
                        repositionPicker()
                        pickerFrame.Visible = true
                    else
                        pickerFrame.Visible = false
                    end
                end)

                local ctrl = {}
                function ctrl:Set(c)
                    color = c
                    colorPreview.BackgroundColor3  = c
                    pickerPreview.BackgroundColor3 = c
                    rInput.Text = tostring(math.floor(c.R * 255))
                    gInput.Text = tostring(math.floor(c.G * 255))
                    bInput.Text = tostring(math.floor(c.B * 255))
                end
                function ctrl:Get() return color end
                return ctrl
            end

            return SectionObj
        end

        return TabObj
    end

    -- ── KEY SYSTEM ──────────────────────────────────────────
    if KeySystem then
        local KeyGui = make("ScreenGui", {
            Name = "ZeloKey",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        }, CoreGui)
        pcall(function() KeyGui.Parent = LP:WaitForChild("PlayerGui") end)

        local KeyOverlay = make("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            ZIndex = 1000,
            Active = true,
        }, KeyGui)

        local cardHeight = KeySubTitle and 280 or 240

        local KeyCard = make("Frame", {
            Name = "Card",
            Size = UDim2.new(0, 400, 0, cardHeight),
            Position = UDim2.new(0.5, -200, 0.5, -cardHeight/2),
            BackgroundColor3 = C.Surface,
            ZIndex = 1001,
            Active = true,
        }, KeyOverlay)
        corner(12, KeyCard)
        stroke(C.Border, 1, KeyCard)

        make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 8),
            BackgroundTransparency = 1,
            Text = KeyTitle,
            TextColor3 = C.White,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1002,
        }, KeyCard)

        if KeySubTitle then
            make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16),
                Position = UDim2.new(0, 0, 0, 38),
                BackgroundTransparency = 1,
                Text = KeySubTitle,
                TextColor3 = C.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 1002,
            }, KeyCard)
        end

        local separatorY = KeySubTitle and 58 or 42
        make("Frame", {
            Size = UDim2.new(1, -40, 0, 1),
            Position = UDim2.new(0, 20, 0, separatorY),
            BackgroundColor3 = C.Border,
            ZIndex = 1002,
        }, KeyCard)

        local noteY = separatorY + 8
        make("TextLabel", {
            Size = UDim2.new(1, -40, 0, 50),
            Position = UDim2.new(0, 20, 0, noteY),
            BackgroundTransparency = 1,
            Text = KeyNote,
            TextColor3 = C.Dim,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1002,
        }, KeyCard)

        local inputY = noteY + 58
        local KeyInput = make("TextBox", {
            Size = UDim2.new(1, -40, 0, 38),
            Position = UDim2.new(0, 20, 0, inputY),
            BackgroundColor3 = C.Surface2,
            Text = "",
            PlaceholderText = "Digite a key aqui...",
            TextColor3 = C.Text,
            PlaceholderColor3 = C.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            ClearTextOnFocus = false,
            ZIndex = 1002,
        }, KeyCard)
        corner(8, KeyInput)
        stroke(C.Border, 1, KeyInput)
        pad(0, 0, 12, 12, KeyInput)

        local btnY = inputY + 46
        local BtnRow = make("Frame", {
            Size = UDim2.new(1, -40, 0, 34),
            Position = UDim2.new(0, 20, 0, btnY),
            BackgroundTransparency = 1,
            ZIndex = 1002,
        }, KeyCard)

        local BtnConfirm = make("TextButton", {
            Size = UDim2.new(0.32, -4, 1, 0),
            BackgroundColor3 = C.Green,
            Text = KeyConfirmText,
            TextColor3 = C.White,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 1002,
        }, BtnRow)
        corner(8, BtnConfirm)

        local BtnGetKey = make("TextButton", {
            Size = UDim2.new(0.32, -4, 1, 0),
            Position = UDim2.new(0.34, 0, 0, 0),
            BackgroundColor3 = C.Blue,
            Text = KeyGetText,
            TextColor3 = C.White,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 1002,
            Visible = GetKeyLink ~= nil,
        }, BtnRow)
        corner(8, BtnGetKey)

        local BtnClose = make("TextButton", {
            Size = UDim2.new(0.32, -4, 1, 0),
            Position = UDim2.new(0.68, 0, 0, 0),
            BackgroundColor3 = C.Surface3,
            Text = KeyCloseText,
            TextColor3 = C.Dim,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 1002,
        }, BtnRow)
        corner(8, BtnClose)
        stroke(C.Border, 1, BtnClose)

        local savedKey = nil
        if SaveKey then
            pcall(function()
                if writefile and readfile then
                    local keyFile = SaveFileName .. ".txt"
                    if isfile(keyFile) then
                        savedKey = readfile(keyFile)
                    end
                end
            end)
        end

        if savedKey and savedKey == ValidKey then
            KeyGui:Destroy()
            WIN.Visible  = true
            WIN_VISIBLE  = true
            setBlur(true)
            Zelo:Notify({Title = KeyTitle, Text = "Key carregada automaticamente!", Duration = 3, Type = "success"})
        end

        onActivated(BtnConfirm, function()
            if KeyInput.Text == ValidKey then
                KeyGui:Destroy()
                WIN.Visible = true
                WIN_VISIBLE = true
                setBlur(true)
                if SaveKey then
                    pcall(function()
                        if writefile then
                            writefile(SaveFileName .. ".txt", ValidKey)
                        end
                    end)
                end
                Zelo:Notify({Title = "Sucesso!", Text = "Key validada com sucesso!", Duration = 3, Type = "success"})
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Key incorreta!"
                KeyInput.PlaceholderColor3 = C.Red
                tween(KeyCard, 0.05, {Position = UDim2.new(0.5, -198, 0.5, -cardHeight/2)})
                task.delay(0.05, function()
                    tween(KeyCard, 0.05, {Position = UDim2.new(0.5, -200, 0.5, -cardHeight/2)})
                end)
                Zelo:Notify({Title = "Erro", Text = "Key incorreta! Tente novamente.", Duration = 3, Type = "error"})
            end
        end)

        if GetKeyLink then
            onActivated(BtnGetKey, function()
                pcall(function() setclipboard(GetKeyLink) end)
                BtnGetKey.Text = "Copiado!"
                task.delay(1.5, function() BtnGetKey.Text = KeyGetText end)
            end)
        end

        onActivated(BtnClose, function()
            KeyGui:Destroy()
            MAIN_GUI:Destroy()
            if BACKDROP then BACKDROP:Destroy() end
        end)
    end

    -- ── DISCORD (sem key system) ────────────────────────────
    if Discord and not KeySystem then
        local DiscordGui = make("ScreenGui", {
            Name = "ZeloDiscord",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        }, CoreGui)
        pcall(function() DiscordGui.Parent = LP:WaitForChild("PlayerGui") end)

        local DiscordOverlay = make("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            ZIndex = 1000,
            Active = true,
        }, DiscordGui)

        local DCard = make("Frame", {
            Size = UDim2.new(0, 400, 0, 200),
            Position = UDim2.new(0.5, -200, 0.5, -100),
            BackgroundColor3 = C.Surface,
            ZIndex = 1001,
            Active = true,
        }, DiscordOverlay)
        corner(12, DCard)
        stroke(C.Border, 1, DCard)

        make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = C.White,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1002,
        }, DCard)

        make("TextLabel", {
            Size = UDim2.new(1, -40, 0, 60),
            Position = UDim2.new(0, 20, 0, 50),
            BackgroundTransparency = 1,
            Text = DiscordText,
            TextColor3 = C.Dim,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1002,
        }, DCard)

        local DCopy = make("TextButton", {
            Size = UDim2.new(0.48, -5, 0, 34),
            Position = UDim2.new(0, 20, 0, 120),
            BackgroundColor3 = C.Blue,
            Text = "Copiar Invite",
            TextColor3 = C.White,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 1002,
        }, DCard)
        corner(8, DCopy)

        local DClose = make("TextButton", {
            Size = UDim2.new(0.48, -5, 0, 34),
            Position = UDim2.new(0.52, 5, 0, 120),
            BackgroundColor3 = C.Surface3,
            Text = "Fechar",
            TextColor3 = C.Dim,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 1002,
        }, DCard)
        corner(8, DClose)
        stroke(C.Border, 1, DClose)

        onActivated(DCopy, function()
            pcall(function() setclipboard(Discord) end)
            DCopy.Text = "Copiado!"
            task.delay(1.5, function() DCopy.Text = "Copiar Invite" end)
        end)

        onActivated(DClose, function()
            DiscordGui:Destroy()
            WIN.Visible = true
            WIN_VISIBLE = true
            setBlur(true)
        end)
    end

    if not KeySystem and not Discord then
        WIN.Visible = true
        WIN_VISIBLE = true
        setBlur(true)
    end

    print("[Zelo] Library v2.4.0 carregada | " .. NAME)
    return WindowObj
end

return Zelo
