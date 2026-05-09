--[[
    ███████╗███████╗██╗      ██████╗
    ╚══███╔╝██╔════╝██║     ██╔═══██╗
      ███╔╝ █████╗  ██║     ██║   ██║
     ███╔╝  ██╔══╝  ██║     ██║   ██║
    ███████╗███████╗███████╗╚██████╔╝
    ╚══════╝╚══════╝╚══════╝ ╚═════╝
    Zelo Library v1.0.0
    UI Library para Roblox

    -- EXEMPLO DE USO:
    local Zelo = loadstring(...)()

    local Window = Zelo:CreateWindow({
        Title        = "MeuScript",
        SubTitle     = "v1.0",
        KeySystem    = true,
        Key          = "minha-chave-123",
        KeyNote      = "Entre no Discord para pegar a key.",
        Discord      = "https://discord.gg/exemplo",
        DiscordText  = "Junte-se ao nosso servidor para suporte e atualizações!",
        ToggleKey    = Enum.KeyCode.RightShift,
        Transparency = 0.05,
        ShowTransparency = true,
        ShowKeybind      = true,
    })

    local Tab = Window:AddTab("Aimbot")
    local Section = Tab:AddSection("Configurações")

    Section:AddButton({ Text = "Disparar", Callback = function() print("!") end })
    Section:AddToggle({ Text = "Aimbot", Default = false, Callback = function(v) print(v) end })
    Section:AddKeybind({ Text = "Ativar", Default = Enum.KeyCode.E, Callback = function(k) print(k) end })
    Section:AddInput({ Text = "FOV", Default = "90", Callback = function(v) print(v) end })
    Section:AddParagraph({ Title = "Aviso", Body = "Use com moderação." })
]]

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local HttpService    = game:GetService("HttpService")
local CoreGui        = game:GetService("CoreGui")

local LP   = Players.LocalPlayer
local NAME = LP.Name

-- ══════════════════════════════════════════════
--  PALETA DE CORES
-- ══════════════════════════════════════════════
local C = {
    BG       = Color3.fromRGB(15,  15,  15),
    Surface  = Color3.fromRGB(22,  22,  22),
    Surface2 = Color3.fromRGB(28,  28,  28),
    Surface3 = Color3.fromRGB(33,  33,  33),
    Border   = Color3.fromRGB(40,  40,  40),
    Border2  = Color3.fromRGB(50,  50,  50),
    Text     = Color3.fromRGB(220, 220, 220),
    Dim      = Color3.fromRGB(130, 130, 130),
    Muted    = Color3.fromRGB(75,  75,  75),
    White    = Color3.fromRGB(235, 235, 235),
    Black    = Color3.fromRGB(15,  15,  15),
    Green    = Color3.fromRGB(76,  175, 125),
    Red      = Color3.fromRGB(200, 70,  70),
    TabBG    = Color3.fromRGB(230, 230, 230),
    Accent   = Color3.fromRGB(255, 255, 255),
}

-- ══════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════
local function make(class, props, parent)
    local o = Instance.new(class)
    if class == "Frame" or class == "ScrollingFrame" then
        o.BorderSizePixel = 0
    end
    for k,v in pairs(props) do
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
    o.Color = col; o.Thickness = t
    o.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    o.Parent = p
    return o
end

local function pad(T,B,L,R,p)
    local o = Instance.new("UIPadding")
    o.PaddingTop    = UDim.new(0,T or 0)
    o.PaddingBottom = UDim.new(0,B or 0)
    o.PaddingLeft   = UDim.new(0,L or 0)
    o.PaddingRight  = UDim.new(0,R or 0)
    o.Parent = p
end

local function listLayout(dir, padding, p)
    local o = Instance.new("UIListLayout")
    o.FillDirection  = dir or Enum.FillDirection.Vertical
    o.Padding        = UDim.new(0, padding or 0)
    o.SortOrder      = Enum.SortOrder.LayoutOrder
    o.Parent = p
    return o
end

local function autoSize(frame, axis)
    frame.AutomaticSize = axis or Enum.AutomaticSize.Y
end

local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad), props):Play()
end

local function greeting()
    local h = tonumber(os.date("%H")) or 12
    if h < 12 then return "Good morning"
    elseif h < 18 then return "Good afternoon"
    else return "Good evening" end
end

-- ══════════════════════════════════════════════
--  LIBRARY
-- ══════════════════════════════════════════════
local Zelo = {}
Zelo.__index = Zelo

function Zelo:CreateWindow(cfg)
    cfg = cfg or {}

    local Title        = cfg.Title        or "Zelo"
    local SubTitle     = cfg.SubTitle     or "v1.0"
    local KeySystem    = cfg.KeySystem    or false
    local ValidKey     = cfg.Key          or ""
    local KeyNote      = cfg.KeyNote      or "Insira a key para continuar."
    local Discord      = cfg.Discord      or nil
    local DiscordText  = cfg.DiscordText  or "Entre no nosso servidor!"
    local ToggleKey    = cfg.ToggleKey    or Enum.KeyCode.RightShift
    local Transparency = math.clamp(cfg.Transparency or 0.05, 0, 0.9)
    local ShowTrans    = cfg.ShowTransparency ~= false
    local ShowKB       = cfg.ShowKeybind      ~= false

    -- estado interno
    local WIN_VISIBLE  = true
    local WIN_ALPHA    = Transparency
    local TABS         = {}
    local ACTIVE_TAB   = nil

    -- ── ScreenGui ──────────────────────────────
    local Gui = make("ScreenGui", {
        Name           = "ZeloLib",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)
    pcall(function()
        Gui.Parent = LP:WaitForChild("PlayerGui")
    end)

    -- ── Overlay (key system / discord) ─────────
    local Overlay = make("Frame", {
        Name                   = "Overlay",
        Size                   = UDim2.new(1,0,1,0),
        BackgroundColor3       = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.45,
        ZIndex                 = 100,
        Visible                = false,
    }, Gui)

    local OverlayCard = make("Frame", {
        Name             = "Card",
        Size             = UDim2.new(0,400,0,220),
        Position         = UDim2.new(0.5,-200,0.5,-110),
        BackgroundColor3 = C.Surface,
        ZIndex           = 101,
    }, Overlay)
    corner(10, OverlayCard)
    stroke(C.Border, 1, OverlayCard)

    -- título overlay
    local OTitle = make("TextLabel", {
        Size             = UDim2.new(1,0,0,40),
        Position         = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text             = "",
        TextColor3       = C.White,
        Font             = Enum.Font.GothamBold,
        TextSize         = 16,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 102,
    }, OverlayCard)

    local OBody = make("TextLabel", {
        Size             = UDim2.new(1,-40,0,60),
        Position         = UDim2.new(0,20,0,46),
        BackgroundTransparency = 1,
        Text             = "",
        TextColor3       = C.Dim,
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextWrapped      = true,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 102,
    }, OverlayCard)

    local OInput = make("TextBox", {
        Size             = UDim2.new(1,-40,0,34),
        Position         = UDim2.new(0,20,0,112),
        BackgroundColor3 = C.Surface2,
        Text             = "",
        PlaceholderText  = "Digite a key...",
        TextColor3       = C.Text,
        PlaceholderColor3 = C.Muted,
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        ClearTextOnFocus = false,
        ZIndex           = 102,
        Visible          = false,
    }, OverlayCard)
    corner(6, OInput)
    stroke(C.Border, 1, OInput)
    pad(0,0,10,10, OInput)

    local OBtn1 = make("TextButton", {
        Size             = UDim2.new(0.5,-25,0,32),
        Position         = UDim2.new(0,20,0,154),
        BackgroundColor3 = C.Surface3,
        Text             = "Confirmar",
        TextColor3       = C.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        AutoButtonColor  = false,
        ZIndex           = 102,
        Visible          = false,
    }, OverlayCard)
    corner(6, OBtn1)
    stroke(C.Border, 1, OBtn1)

    local OBtn2 = make("TextButton", {
        Size             = UDim2.new(0.5,-25,0,32),
        Position         = UDim2.new(0.5,5,0,154),
        BackgroundColor3 = C.Surface3,
        Text             = "Fechar",
        TextColor3       = C.Dim,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        AutoButtonColor  = false,
        ZIndex           = 102,
    }, OverlayCard)
    corner(6, OBtn2)
    stroke(C.Border, 1, OBtn2)

    -- ── Janela principal ───────────────────────
    local Win = make("Frame", {
        Name             = "Window",
        Size             = UDim2.new(0, 720, 0.78, 0),
        Position         = UDim2.new(0.5,-360,0.5,-0.39*768),
        BackgroundColor3 = C.BG,
        BackgroundTransparency = WIN_ALPHA,
        Active           = true,
        Draggable        = true,
    }, Gui)
    Win.Position = UDim2.new(0.5,-360,0.5,-280)
    corner(10, Win)
    stroke(C.Border, 1, Win)

    -- sombra
    make("ImageLabel", {
        Size               = UDim2.new(1,60,1,60),
        Position           = UDim2.new(0,-30,0,-30),
        BackgroundTransparency = 1,
        Image              = "rbxassetid://6014261993",
        ImageColor3        = Color3.fromRGB(0,0,0),
        ImageTransparency  = 0.5,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(49,49,450,450),
        ZIndex             = 0,
    }, Win)

    -- ── Topbar ─────────────────────────────────
    local TB = make("Frame", {
        Name             = "Topbar",
        Size             = UDim2.new(1,0,0,44),
        BackgroundColor3 = C.BG,
        BackgroundTransparency = WIN_ALPHA,
    }, Win)

    make("Frame", {
        Size             = UDim2.new(1,0,0,1),
        Position         = UDim2.new(0,0,1,-1),
        BackgroundColor3 = C.Border,
    }, TB)

    -- logo
    local LogoF = make("Frame", { Size=UDim2.new(0,82,1,0), BackgroundTransparency=1 }, TB)
    make("TextLabel", {
        Size=UDim2.new(1,-10,0,16), Position=UDim2.new(0,12,0,7),
        BackgroundTransparency=1, Text=Title,
        TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, LogoF)
    make("TextLabel", {
        Size=UDim2.new(1,-10,0,11), Position=UDim2.new(0,12,0,25),
        BackgroundTransparency=1, Text=SubTitle,
        TextColor3=C.Muted, Font=Enum.Font.Gotham, TextSize=9,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, LogoF)

    make("Frame", {
        Size=UDim2.new(0,1,0,24), Position=UDim2.new(0,84,0.5,-12),
        BackgroundColor3=C.Border,
    }, TB)

    -- nav frame (tabs dinâmicas)
    local NavF = make("Frame", {
        Name="Nav", Size=UDim2.new(1,-310,1,0), Position=UDim2.new(0,92,0,0),
        BackgroundTransparency=1,
    }, TB)
    local NavLayout = listLayout(Enum.FillDirection.Horizontal, 2, NavF)
    NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pad(0,0,4,0,NavF)

    -- tab search
    local SearchBox = make("TextBox", {
        Name="SearchBox",
        Size=UDim2.new(0,140,0,26),
        Position=UDim2.new(1,-300,0.5,-13),
        BackgroundColor3=C.Surface2,
        Text="", PlaceholderText="Buscar...",
        TextColor3=C.Text, PlaceholderColor3=C.Muted,
        Font=Enum.Font.Gotham, TextSize=10,
        ClearTextOnFocus=false,
    }, TB)
    corner(6, SearchBox)
    stroke(C.Border, 1, SearchBox)
    pad(0,0,8,8,SearchBox)

    -- botão settings (nome do jogador)
    local UserBtn = make("TextButton", {
        Name="UserBtn",
        Size=UDim2.new(0,120,0,28),
        Position=UDim2.new(1,-128,0.5,-14),
        BackgroundTransparency=1,
        BackgroundColor3=C.Surface2,
        Text=NAME.."  ▾",
        TextColor3=C.Dim,
        Font=Enum.Font.GothamBold, TextSize=10,
        AutoButtonColor=false,
    }, TB)
    corner(6, UserBtn)

    UserBtn.MouseEnter:Connect(function()
        UserBtn.BackgroundTransparency=0
        UserBtn.TextColor3=C.Text
    end)
    UserBtn.MouseLeave:Connect(function()
        UserBtn.BackgroundTransparency=1
        UserBtn.TextColor3=C.Dim
    end)

    -- ── HUB SETTINGS panel (abre ao clicar no nome) ──
    local HubPanel = make("Frame", {
        Name             = "HubSettings",
        Size             = UDim2.new(0,220,0,0),
        Position         = UDim2.new(1,-228,0,46),
        BackgroundColor3 = C.Surface,
        ClipsDescendants = true,
        ZIndex           = 50,
        Visible          = false,
    }, Win)
    corner(8, HubPanel)
    stroke(C.Border, 1, HubPanel)

    local HubInner = make("Frame", {
        Size=UDim2.new(1,0,0,0), BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y, ZIndex=51,
    }, HubPanel)
    autoSize(HubInner)
    listLayout(Enum.FillDirection.Vertical, 0, HubInner)
    pad(8,8,0,0,HubInner)

    local function hubLabel(text)
        local lbl = make("TextLabel", {
            Size=UDim2.new(1,0,0,11), BackgroundTransparency=1,
            Text=text, TextColor3=C.Muted,
            Font=Enum.Font.GothamBold, TextSize=8,
            TextXAlignment=Enum.TextXAlignment.Left,
            ZIndex=51,
        }, HubInner)
        pad(0,0,12,12,lbl)
        return lbl
    end

    local hubOpen = false
    local function toggleHub()
        hubOpen = not hubOpen
        HubPanel.Visible = true
        local targetH = hubOpen and HubInner.AbsoluteSize.Y or 0
        tween(HubPanel, 0.2, {Size=UDim2.new(0,220,0,targetH)})
        if not hubOpen then
            task.delay(0.21, function() HubPanel.Visible = false end)
        end
    end
    UserBtn.MouseButton1Click:Connect(toggleHub)

    -- ── Seção Hub: Toggle Key ───────────────────
    if ShowKB then
        hubLabel("KEYBIND PARA ESCONDER")
        local kbRow = make("Frame", {
            Size=UDim2.new(1,0,0,36), BackgroundTransparency=1, ZIndex=51,
        }, HubInner)
        pad(0,4,12,12,kbRow)

        local kbBox = make("TextButton", {
            Size=UDim2.new(1,0,0,28),
            BackgroundColor3=C.Surface2,
            Text="["..tostring(ToggleKey).." ]",
            TextColor3=C.Text, Font=Enum.Font.GothamBold, TextSize=10,
            AutoButtonColor=false, ZIndex=52,
        }, kbRow)
        corner(6, kbBox)
        stroke(C.Border, 1, kbBox)

        local listeningKB = false
        kbBox.MouseButton1Click:Connect(function()
            listeningKB = true
            kbBox.Text = "[ Pressione uma tecla... ]"
            kbBox.TextColor3 = C.Dim
        end)
        UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if listeningKB and inp.UserInputType == Enum.UserInputType.Keyboard then
                ToggleKey = inp.KeyCode
                kbBox.Text = "[ "..tostring(inp.KeyCode).." ]"
                kbBox.TextColor3 = C.Text
                listeningKB = false
            end
        end)
    end

    -- ── Seção Hub: Transparência ────────────────
    if ShowTrans then
        hubLabel("TRANSPARÊNCIA")
        local alphaRow = make("Frame", {
            Size=UDim2.new(1,0,0,40), BackgroundTransparency=1, ZIndex=51,
        }, HubInner)
        pad(0,6,12,12,alphaRow)

        local sliderBG = make("Frame", {
            Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0,16),
            BackgroundColor3=C.Surface3, ZIndex=52,
        }, alphaRow)
        corner(3, sliderBG)
        stroke(C.Border2, 1, sliderBG)

        local sliderFill = make("Frame", {
            Size=UDim2.new(WIN_ALPHA,0,1,0),
            BackgroundColor3=C.White, ZIndex=53,
        }, sliderBG)
        corner(3, sliderFill)

        local alphaLbl = make("TextLabel", {
            Size=UDim2.new(1,0,0,14), BackgroundTransparency=1,
            Text=math.floor(WIN_ALPHA*100).."%",
            TextColor3=C.Dim, Font=Enum.Font.Gotham, TextSize=9,
            TextXAlignment=Enum.TextXAlignment.Right, ZIndex=52,
        }, alphaRow)

        local dragging = false
        sliderBG.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if dragging then
                local rel = math.clamp(
                    (UserInputService:GetMouseLocation().X - sliderBG.AbsolutePosition.X)
                    / sliderBG.AbsoluteSize.X, 0, 1)
                WIN_ALPHA = rel
                sliderFill.Size = UDim2.new(rel,0,1,0)
                alphaLbl.Text   = math.floor(rel*100).."%"
                Win.BackgroundTransparency = rel
                TB.BackgroundTransparency  = rel
            end
        end)
    end

    -- ── Discord invite ──────────────────────────
    if Discord then
        hubLabel("DISCORD")
        local dcBtn = make("TextButton", {
            Size=UDim2.new(1,0,0,28),
            BackgroundColor3=Color3.fromRGB(88,101,242),
            Text="Abrir convite",
            TextColor3=Color3.fromRGB(255,255,255),
            Font=Enum.Font.GothamBold, TextSize=10,
            AutoButtonColor=false, ZIndex=52,
        }, HubInner)
        corner(6, dcBtn)
        pad(0,8,12,12,dcBtn)

        dcBtn.MouseButton1Click:Connect(function()
            hubOpen = false
            HubPanel.Visible = false

            OTitle.Text = "Discord"
            OBody.Text  = DiscordText
            OInput.Visible = false
            OBtn1.Text     = "Copiar Link"
            OBtn1.Visible  = true
            OBtn2.Text     = "Fechar"
            Overlay.Visible = true

            OBtn1.MouseButton1Click:Connect(function()
                setclipboard(Discord)
                OBtn1.Text = "Copiado!"
                task.delay(1.5, function() OBtn1.Text = "Copiar Link" end)
            end)
            OBtn2.MouseButton1Click:Connect(function()
                Overlay.Visible = false
            end)
        end)
    end

    -- ── Area de conteúdo (sidebar + conteúdo tab) ─
    local Body = make("Frame", {
        Name="Body", Size=UDim2.new(1,0,1,-44), Position=UDim2.new(0,0,0,44),
        BackgroundTransparency=1,
    }, Win)

    -- sidebar (tabs verticais + search section)
    local Sidebar = make("Frame", {
        Name="Sidebar", Size=UDim2.new(0,150,1,0),
        BackgroundColor3=C.Surface, BackgroundTransparency=0,
    }, Body)

    make("Frame", {
        Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=C.Border,
    }, Sidebar)

    -- search de section
    local SecSearch = make("TextBox", {
        Size=UDim2.new(1,-16,0,28), Position=UDim2.new(0,8,0,8),
        BackgroundColor3=C.Surface2,
        Text="", PlaceholderText="Buscar seção...",
        TextColor3=C.Text, PlaceholderColor3=C.Muted,
        Font=Enum.Font.Gotham, TextSize=10,
        ClearTextOnFocus=false,
    }, Sidebar)
    corner(6, SecSearch)
    stroke(C.Border, 1, SecSearch)
    pad(0,0,8,8,SecSearch)

    local SideScroll = make("ScrollingFrame", {
        Size=UDim2.new(1,0,1,-50), Position=UDim2.new(0,0,0,44),
        BackgroundTransparency=1,
        ScrollBarThickness=3,
        ScrollBarImageColor3=C.Border,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ElasticBehavior=Enum.ElasticBehavior.Never,
    }, Sidebar)
    listLayout(Enum.FillDirection.Vertical, 2, SideScroll)
    pad(4,4,6,6,SideScroll)

    -- conteúdo da tab (painel direito)
    local ContentArea = make("ScrollingFrame", {
        Name="Content",
        Size=UDim2.new(1,-150,1,0), Position=UDim2.new(0,150,0,0),
        BackgroundTransparency=1,
        ScrollBarThickness=3,
        ScrollBarImageColor3=C.Border,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ElasticBehavior=Enum.ElasticBehavior.Never,
    }, Body)
    pad(14,14,14,14,ContentArea)
    listLayout(Enum.FillDirection.Vertical, 10, ContentArea)

    -- ── Toggle visibilidade ─────────────────────
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == ToggleKey then
            WIN_VISIBLE = not WIN_VISIBLE
            tween(Win, 0.2, {
                Size = WIN_VISIBLE
                    and UDim2.new(0,720,0.78,0)
                    or  UDim2.new(0,720,0,0),
            })
            Win.Visible = WIN_VISIBLE or true
            if not WIN_VISIBLE then
                task.delay(0.21, function() Win.Visible = false end)
            else
                Win.Visible = true
            end
        end
    end)

    -- ── Tab search ─────────────────────────────
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = SearchBox.Text:lower()
        for _, btn2 in pairs(NavF:GetChildren()) do
            if btn2:IsA("TextButton") then
                btn2.Visible = q=="" or btn2.Text:lower():find(q,1,true) ~= nil
            end
        end
    end)

    -- ── Section search ─────────────────────────
    SecSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local q = SecSearch.Text:lower()
        for _, sec in pairs(ContentArea:GetChildren()) do
            if sec:IsA("Frame") and sec.Name == "Section" then
                local match = q=="" or sec:GetAttribute("Title"):lower():find(q,1,true)
                sec.Visible = match ~= nil and match ~= false
            end
        end
    end)

    -- ══════════════════════════════════════════
    --  WINDOW OBJECT
    -- ══════════════════════════════════════════
    local WindowObj = {}

    -- seleciona tab visualmente
    local function selectTab(tabObj)
        if ACTIVE_TAB then
            ACTIVE_TAB.Btn.BackgroundTransparency = 1
            ACTIVE_TAB.Btn.TextColor3 = C.Dim
            ACTIVE_TAB.Frame.Visible = false
        end
        ACTIVE_TAB = tabObj
        tabObj.Btn.BackgroundTransparency = 0
        tabObj.Btn.BackgroundColor3       = C.TabBG
        tabObj.Btn.TextColor3             = C.Black
        tabObj.Frame.Visible = true
    end

    -- ── AddTab ─────────────────────────────────
    function WindowObj:AddTab(name)
        -- botão da tab na topbar
        local tabBtn = make("TextButton", {
            Name=name,
            Size=UDim2.new(0,70,0,30),
            BackgroundColor3=C.Surface2,
            BackgroundTransparency=1,
            Text=name,
            TextColor3=C.Dim,
            Font=Enum.Font.GothamBold, TextSize=10,
            AutoButtonColor=false,
        }, NavF)
        corner(6, tabBtn)

        -- frame de conteúdo (compartilha o ContentArea — cada tab tem seu frame)
        local tabFrame = make("Frame", {
            Name="Tab_"..name,
            Size=UDim2.new(1,0,0,0),
            BackgroundTransparency=1,
            AutomaticSize=Enum.AutomaticSize.Y,
            Visible=false,
        }, ContentArea)
        autoSize(tabFrame)
        listLayout(Enum.FillDirection.Vertical, 10, tabFrame)

        local tabObj = { Btn=tabBtn, Frame=tabFrame, Sections={} }
        table.insert(TABS, tabObj)

        tabBtn.MouseEnter:Connect(function()
            if ACTIVE_TAB ~= tabObj then
                tabBtn.BackgroundTransparency=0
                tabBtn.BackgroundColor3=C.Surface2
                tabBtn.TextColor3=C.Text
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if ACTIVE_TAB ~= tabObj then
                tabBtn.BackgroundTransparency=1
                tabBtn.TextColor3=C.Dim
            end
        end)
        tabBtn.MouseButton1Click:Connect(function() selectTab(tabObj) end)

        if #TABS == 1 then selectTab(tabObj) end

        -- botão na sidebar também
        local sideBtn = make("TextButton", {
            Name="Side_"..name,
            Size=UDim2.new(1,0,0,30),
            BackgroundTransparency=1,
            BackgroundColor3=C.Surface2,
            Text=name,
            TextColor3=C.Dim,
            Font=Enum.Font.GothamBold, TextSize=10,
            AutoButtonColor=false,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, SideScroll)
        corner(6, sideBtn)
        pad(0,0,10,0,sideBtn)

        sideBtn.MouseButton1Click:Connect(function() selectTab(tabObj) end)

        -- ── Tab object ──────────────────────────
        local TabObj = {}

        -- ── AddSection ─────────────────────────
        function TabObj:AddSection(sTitle)
            local secFrame = make("Frame", {
                Name="Section",
                Size=UDim2.new(1,0,0,0),
                BackgroundColor3=C.Surface,
                AutomaticSize=Enum.AutomaticSize.Y,
            }, tabFrame)
            secFrame:SetAttribute("Title", sTitle or "")
            corner(8, secFrame)
            stroke(C.Border, 1, secFrame)
            autoSize(secFrame)

            local secInner = make("Frame", {
                Size=UDim2.new(1,0,0,0),
                BackgroundTransparency=1,
                AutomaticSize=Enum.AutomaticSize.Y,
            }, secFrame)
            autoSize(secInner)
            pad(10,10,12,12,secInner)
            listLayout(Enum.FillDirection.Vertical, 6, secInner)

            -- cabeçalho da section
            if sTitle and sTitle ~= "" then
                local hdrRow = make("Frame", {
                    Size=UDim2.new(1,0,0,22),
                    BackgroundTransparency=1,
                    LayoutOrder=0,
                }, secInner)

                make("TextLabel", {
                    Size=UDim2.new(1,0,1,0),
                    BackgroundTransparency=1,
                    Text=sTitle:upper(),
                    TextColor3=C.Muted,
                    Font=Enum.Font.GothamBold, TextSize=8,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, hdrRow)

                make("Frame", {
                    Size=UDim2.new(1,0,0,1),
                    Position=UDim2.new(0,0,1,-1),
                    BackgroundColor3=C.Border,
                }, hdrRow)
            end

            -- ── SectionObj ─────────────────────────
            local SectionObj = {}
            local orderCount = 1

            local function nextOrder()
                orderCount = orderCount + 1
                return orderCount
            end

            -- ── Elemento base ──────────────────────
            local function makeRow(h)
                local row = make("Frame", {
                    Size=UDim2.new(1,0,0,h or 32),
                    BackgroundTransparency=1,
                    LayoutOrder=nextOrder(),
                }, secInner)
                return row
            end

            -- ─────────────────────────────────────────
            --  BUTTON
            -- ─────────────────────────────────────────
            function SectionObj:AddButton(opts)
                opts = opts or {}
                local row = makeRow(32)

                local b = make("TextButton", {
                    Size=UDim2.new(1,0,1,0),
                    BackgroundColor3=C.Surface2,
                    Text=opts.Text or "Button",
                    TextColor3=C.Text,
                    Font=Enum.Font.GothamBold, TextSize=11,
                    AutoButtonColor=false,
                }, row)
                corner(6, b)
                stroke(C.Border, 1, b)

                b.MouseEnter:Connect(function()
                    tween(b, 0.12, {BackgroundColor3=C.Surface3})
                end)
                b.MouseLeave:Connect(function()
                    tween(b, 0.12, {BackgroundColor3=C.Surface2})
                end)
                b.MouseButton1Click:Connect(function()
                    tween(b, 0.06, {BackgroundColor3=C.Border})
                    task.delay(0.1, function()
                        tween(b, 0.1, {BackgroundColor3=C.Surface2})
                    end)
                    if opts.Callback then opts.Callback() end
                end)

                return b
            end

            -- ─────────────────────────────────────────
            --  TOGGLE
            -- ─────────────────────────────────────────
            function SectionObj:AddToggle(opts)
                opts = opts or {}
                local val = opts.Default or false
                local row = makeRow(32)

                local bg = make("Frame", {
                    Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size=UDim2.new(1,-54,1,0), Position=UDim2.new(0,10,0,0),
                    BackgroundTransparency=1,
                    Text=opts.Text or "Toggle",
                    TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, bg)

                local pill = make("Frame", {
                    Size=UDim2.new(0,36,0,18),
                    Position=UDim2.new(1,-46,0.5,-9),
                    BackgroundColor3=val and C.Green or C.Surface3,
                }, bg)
                corner(9, pill)
                stroke(C.Border, 1, pill)

                local knob = make("Frame", {
                    Size=UDim2.new(0,12,0,12),
                    Position=val and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
                    BackgroundColor3=C.White,
                }, pill)
                corner(6, knob)

                local function setToggle(v)
                    val = v
                    tween(pill, 0.15, {BackgroundColor3=v and C.Green or C.Surface3})
                    tween(knob, 0.15, {
                        Position=v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
                    })
                    if opts.Callback then opts.Callback(v) end
                end

                bg.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        setToggle(not val)
                    end
                end)

                local ctrl = {}
                function ctrl:Set(v) setToggle(v) end
                function ctrl:Get() return val end
                return ctrl
            end

            -- ─────────────────────────────────────────
            --  KEYBIND
            -- ─────────────────────────────────────────
            function SectionObj:AddKeybind(opts)
                opts = opts or {}
                local currentKey = opts.Default or Enum.KeyCode.Unknown
                local listening  = false
                local row = makeRow(32)

                local bg = make("Frame", {
                    Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size=UDim2.new(1,-100,1,0), Position=UDim2.new(0,10,0,0),
                    BackgroundTransparency=1,
                    Text=opts.Text or "Keybind",
                    TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, bg)

                local keyBtn = make("TextButton", {
                    Size=UDim2.new(0,80,0,22),
                    Position=UDim2.new(1,-86,0.5,-11),
                    BackgroundColor3=C.Surface3,
                    Text="["..tostring(currentKey).."]",
                    TextColor3=C.Dim, Font=Enum.Font.GothamBold, TextSize=9,
                    AutoButtonColor=false,
                }, bg)
                corner(5, keyBtn)
                stroke(C.Border, 1, keyBtn)

                keyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    keyBtn.Text = "[ ... ]"
                    keyBtn.TextColor3 = C.Muted
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if gp then return end
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = inp.KeyCode
                        keyBtn.Text = "["..tostring(inp.KeyCode).."]"
                        keyBtn.TextColor3 = C.Dim
                        listening = false
                        if opts.Callback then opts.Callback(currentKey) end
                    end
                end)

                local ctrl = {}
                function ctrl:Get() return currentKey end
                return ctrl
            end

            -- ─────────────────────────────────────────
            --  INPUT
            -- ─────────────────────────────────────────
            function SectionObj:AddInput(opts)
                opts = opts or {}
                local row = makeRow(32)

                local bg = make("Frame", {
                    Size=UDim2.new(1,0,1,0), BackgroundColor3=C.Surface2,
                }, row)
                corner(6, bg)
                stroke(C.Border, 1, bg)

                make("TextLabel", {
                    Size=UDim2.new(0.45,0,1,0), Position=UDim2.new(0,10,0,0),
                    BackgroundTransparency=1,
                    Text=opts.Text or "Input",
                    TextColor3=C.Text, Font=Enum.Font.Gotham, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, bg)

                local box = make("TextBox", {
                    Size=UDim2.new(0.5,-10,0,22),
                    Position=UDim2.new(0.5,0,0.5,-11),
                    BackgroundColor3=C.Surface3,
                    Text=opts.Default or "",
                    PlaceholderText=opts.Placeholder or "...",
                    TextColor3=C.Text, PlaceholderColor3=C.Muted,
                    Font=Enum.Font.Gotham, TextSize=11,
                    ClearTextOnFocus=false,
                }, bg)
                corner(5, box)
                stroke(C.Border, 1, box)
                pad(0,0,8,8,box)

                box.FocusLost:Connect(function(enter)
                    if opts.Callback then opts.Callback(box.Text) end
                end)

                local ctrl = {}
                function ctrl:Get() return box.Text end
                function ctrl:Set(v) box.Text = tostring(v) end
                return ctrl
            end

            -- ─────────────────────────────────────────
            --  PARAGRAPH
            -- ─────────────────────────────────────────
            function SectionObj:AddParagraph(opts)
                opts = opts or {}
                local row = make("Frame", {
                    Size=UDim2.new(1,0,0,0),
                    BackgroundColor3=C.Surface2,
                    AutomaticSize=Enum.AutomaticSize.Y,
                    LayoutOrder=nextOrder(),
                }, secInner)
                corner(6, row)
                stroke(C.Border, 1, row)
                pad(8,8,10,10,row)
                autoSize(row)
                local inner = make("Frame", {
                    Size=UDim2.new(1,0,0,0),
                    BackgroundTransparency=1,
                    AutomaticSize=Enum.AutomaticSize.Y,
                }, row)
                autoSize(inner)
                listLayout(Enum.FillDirection.Vertical, 4, inner)

                if opts.Title and opts.Title ~= "" then
                    make("TextLabel", {
                        Size=UDim2.new(1,0,0,14),
                        BackgroundTransparency=1,
                        Text=opts.Title,
                        TextColor3=C.White, Font=Enum.Font.GothamBold, TextSize=11,
                        TextXAlignment=Enum.TextXAlignment.Left,
                    }, inner)
                end

                local bodyLbl = make("TextLabel", {
                    Size=UDim2.new(1,0,0,0),
                    BackgroundTransparency=1,
                    Text=opts.Body or "",
                    TextColor3=C.Dim, Font=Enum.Font.Gotham, TextSize=10,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    TextWrapped=true,
                    AutomaticSize=Enum.AutomaticSize.Y,
                }, inner)
                autoSize(bodyLbl)

                local ctrl = {}
                function ctrl:SetBody(v) bodyLbl.Text = tostring(v) end
                return ctrl
            end

            return SectionObj
        end -- AddSection

        return TabObj
    end -- AddTab

    -- ── Key System ─────────────────────────────
    if KeySystem then
        OTitle.Text  = "Key System"
        OBody.Text   = KeyNote
        OInput.Visible = true
        OBtn1.Visible  = true
        OBtn1.Text     = "Confirmar"
        OBtn2.Text     = "Sair"
        Overlay.Visible = true

        OBtn1.MouseButton1Click:Connect(function()
            if OInput.Text == ValidKey then
                Overlay.Visible = false
            else
                OInput.Text = ""
                OInput.PlaceholderText = "Key incorreta, tente novamente..."
                OInput.PlaceholderColor3 = C.Red
                tween(OverlayCard, 0.05, {Position=UDim2.new(0.5,-198,0.5,-110)})
                task.delay(0.05, function()
                    tween(OverlayCard, 0.05, {Position=UDim2.new(0.5,-200,0.5,-110)})
                end)
            end
        end)
        OBtn2.MouseButton1Click:Connect(function()
            Gui:Destroy()
        end)
    end

    -- ── Discord (se não tem key system, mostra na abertura) ──
    if Discord and not KeySystem then
        OTitle.Text    = Title
        OBody.Text     = DiscordText
        OInput.Visible = false
        OBtn1.Visible  = true
        OBtn1.Text     = "Copiar Invite"
        OBtn2.Text     = "Fechar"
        Overlay.Visible = true

        OBtn1.MouseButton1Click:Connect(function()
            setclipboard(Discord)
            OBtn1.Text = "Copiado!"
            task.delay(1.5, function() OBtn1.Text = "Copiar Invite" end)
        end)
        OBtn2.MouseButton1Click:Connect(function()
            Overlay.Visible = false
        end)
    end

    print("[Zelo] Library carregada | "..NAME)
    return WindowObj
end

return Zelo
