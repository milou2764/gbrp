local frame
local defaultSkin = Material("gwenskin/gmoddefault.png")
local corner16 = surface.GetTextureID("gui/corner16")

net.Receive("GBRP::doorsinit",function()
    gbrp.doors = {}
    for k = 1,net.ReadInt(32) do
        gbrp.doors[net.ReadInt(32)] = net.ReadTable()
    end
end)
net.Receive("GBRP::bankreception", function()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gender = net.ReadString()
    surface.PlaySound(gbrp.voices[gender][math.random(1,#gbrp.voices[gender])])
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1016,550)
    frame:SetPos(gbrp.ScreenW / 2 -frame:GetWide() / 2, gbrp.ScreenH)
    frame:MakePopup()
    frame.mat = Material("gui/gbrp/bank/frame.png")
    function frame:Think()
        if self:GetY() ~= gbrp.ScreenH - 550 then
            self:SetY(self:GetY() - 25)
        end
    end
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetFont("Bank")
        surface.SetTextPos(233,366)
        surface.SetTextColor(0,0,0,255)
        surface.DrawText("SOLDE: " .. gbrp.formatMoney(ply:GetNWInt("GBRP::balance")))
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(745,22)

    local depositButton = vgui.Create("GBRPButton",frame)
    depositButton.mat = Material("gui/gbrp/bank/deposit.png")
    depositButton.hoveredMat = Material("gui/gbrp/bank/depositrollover.png")
    depositButton:SetPos(288,182)
    depositButton:SetSize(166,65)
    depositButton.DoClick = function()
        local amount = ply:GetNWInt("GBRP::launderedmoney")
        local personnalAmount = ply:GetNWInt("GBRP::personnalLaunderedMoney")
        if amount > 0 then
            net.Start("GBRP::bankdeposit")
            net.SendToServer()
            frame:Remove()
            GAMEMODE:AddNotify("Vous avez déposé " .. gbrp.formatMoney(amount) .. ".",0,2)
            surface.PlaySound("gui/gbrp/bank/deposit.wav")
        elseif personnalAmount > 0 then
            net.Start("GBRP::personnalBankDeposit")
            net.SendToServer()
            GAMEMODE:AddNotify("Vous avez déposé " .. gbrp.formatMoney(personnalAmount) .. " sur votre compte personnel.",0,2)
        else
            GAMEMODE:AddNotify("Vous n'avez pas d'argent blanchi sur vous.",1,2)
        end
    end

    local withdrawButton = vgui.Create("GBRPButton",frame)
    withdrawButton.mat = Material("gui/gbrp/bank/withdraw.png")
    withdrawButton.hoveredMat = Material("gui/gbrp/bank/withdrawrollover.png")
    withdrawButton:SetPos(569,182)
    withdrawButton:SetSize(166,65)
    withdrawButton.DoClick = function()
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry:RequestFocus()
        textEntry.OnEnter = function(self)
            local amount = tonumber(self:GetValue())
            if amount > 0 and ply:GetNWInt("GBRP::balance") - amount >= 0 then
                net.Start("GBRP::bankwithdraw")
                net.WriteUInt(amount,32)
                net.SendToServer()
                GAMEMODE:AddNotify("Vous avez retiré $" .. amount .. ".",0,2)
                surface.PlaySound("gui/gbrp/bank/withdraw.wav")
            elseif amount <= 0 then
                GAMEMODE:AddNotify("Valeur non valide.",1,2)
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
            self:Remove()
        end
    end
end)
net.Receive("GBRP::jewelrystoreReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local shopbalMat = Material("gui/gbrp/jewelrystore/shopbal.png")
    local shopvalMat = Material("gui/gbrp/jewelrystore/shopval.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1217,964)
    frame:CenterHorizontal(.5)
    frame:SetY(gbrp.FormatY(116))
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/jewelrystore/frame.png")
    frame.panelMat = Material("gui/gbrp/jewelrystore/panel.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(self.panelMat)
        surface.DrawTexturedRect(gbrp.FormatX(76),gbrp.FormatY(99),gbrp.FormatX(403),gbrp.FormatY(531))
        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(gbrp.FormatX(93),gbrp.FormatY(644))
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        surface.SetFont("BankSmall")
        surface.SetTextPos(gbrp.FormatX(193),gbrp.FormatY(322))
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop:GetPrice()))
        surface.SetTextPos(gbrp.FormatX(193),gbrp.FormatY(352))
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop:GetValue()))
    end

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(643,201)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea.mat = Material("gui/gbrp/jewelrystore/customerarea.png")
    customerArea.hoveredMat = Material("gui/gbrp/jewelrystore/customerArearollover.png")
    customerArea:SetSize(369,126)
    customerArea:SetPos(643,416)
    function customerArea:DoClick()
        surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        if shop:GetGang() == gang then
            buy:Remove()
            self:Remove()

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash.mat = Material("gui/gbrp/jewelrystore/dropcash.png")
            dropcash.hoveredMat = Material("gui/gbrp/jewelrystore/dropcashrollover.png")
            dropcash:SetPos(gbrp.FormatX(83),gbrp.FormatY(166))
            dropcash:SetSize(gbrp.FormatX(321),gbrp.FormatX(105))

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw.mat = Material("gui/gbrp/jewelrystore/withdraw.png")
            withdraw.hoveredMat = Material("gui/gbrp/jewelrystore/withdrawrollover.png")
            withdraw:SetSize(gbrp.FormatX(321),gbrp.FormatY(105))
            withdraw:SetPos(gbrp.FormatX(448),gbrp.FormatY(166))

            local sell = vgui.Create("SellShopButton",frame)
            sell.mat = Material("gui/gbrp/jewelrystore/sell.png")
            sell.hoveredMat = Material("gui/gbrp/jewelrystore/sellrollover.png")
            sell:SetSize(gbrp.FormatX(321),gbrp.FormatY(105))
            sell:SetPos(gbrp.FormatX(816),gbrp.FormatY(166))

            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())

                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(gbrp.FormatX(93),gbrp.FormatY(644))
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end

                surface.SetMaterial(shopbalMat)
                surface.DrawTexturedRect(gbrp.FormatX(238),gbrp.FormatY(489),gbrp.FormatX(321),gbrp.FormatY(68))

                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(gbrp.FormatX(682),gbrp.FormatY(489),gbrp.FormatX(321),gbrp.FormatY(68))

                surface.SetFont("BankSmall")
                surface.SetTextPos(gbrp.FormatX(349),gbrp.FormatY(525))
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(gbrp.FormatX(84),gbrp.FormatY(385),gbrp.FormatX(1053),gbrp.FormatY(27))
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(gbrp.FormatX(84),gbrp.FormatY(385),gbrp.FormatX(1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2)), gbrp.FormatY(27))

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(gbrp.FormatX(577),gbrp.FormatY(331))
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(gbrp.FormatX(805),gbrp.FormatY(525))
                surface.DrawText(gbrp.formatMoney(shop:GetValue()))
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1112,48)
end)
net.Receive("GBRP::clubReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local subpanelMat = Material("gui/gbrp/club/subpanel.png")
    local shopbalMat = Material("gui/gbrp/club/shopbal.png")
    local shopvalMat = Material("gui/gbrp/club/shopval.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1396,716)
    frame:SetPos(371,116)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/club/frame.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(subpanelMat)
        surface.DrawTexturedRect(149,95,403,531)
        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(166,640)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        surface.SetFont("BankSmall")
        surface.SetTextPos(266,319)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop:GetPrice()))
        surface.SetTextPos(266,349)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop:GetValue()))
    end

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(716,197)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea.mat = Material("gui/gbrp/jewelrystore/customerarea.png")
    customerArea.hoveredMat = Material("gui/gbrp/jewelrystore/customerarearollover.png")
    customerArea:SetSize(369,126)
    customerArea:SetPos(716,412)
    function customerArea:DoClick()
        surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        if shop:GetGang() == gang then
            buy:Remove()
            self:Remove()
            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash.mat = Material("gui/gbrp/jewelrystore/dropcash.png")
            dropcash.hoveredMat = Material("gui/gbrp/jewelrystore/dropcashrollover.png")
            dropcash:SetPos(156,162)
            dropcash:SetSize(321,105)

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw.mat = Material("gui/gbrp/jewelrystore/withdraw.png")
            withdraw.hoveredMat = Material("gui/gbrp/jewelrystore/withdrawrollover.png")
            withdraw:SetSize(321,105)
            withdraw:SetPos(521,162)

            local sell = vgui.Create("SellShopButton",frame)
            sell.mat = Material("gui/gbrp/jewelrystore/sell.png")
            sell.hoveredMat = Material("gui/gbrp/jewelrystore/sellrollover.png")
            sell:SetSize(321,105)
            sell:SetPos(889,162)

            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())

                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(166,640)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end

                surface.SetMaterial(shopbalMat)
                surface.DrawTexturedRect(270,485,321,68)

                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(740,485,321,68)

                surface.SetFont("BankSmall")
                surface.SetTextPos(349,520)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(157,381,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(157,381,1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2), 27)

                surface.SetFont("Bank")
                surface.SetTextColor(255,255,255,255)
                surface.SetTextPos(652,332)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(830,520)
                surface.DrawText(gbrp.formatMoney(shop:GetValue()))
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1189,45)
end)
net.Receive("GBRP::gasstationReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local leftpanelMat = Material("gui/gbrp/gasstation/page1/leftpanel.png")
    local rightpanelMat = Material("gui/gbrp/gasstation/page1/rightpanel.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1376,1005)
    frame:SetPos(287,75)
    frame:MakePopup()
    frame.mat = Material("gui/gbrp/gasstation/frame.png")
    frame.shop = shop
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        -- F R A M E --
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        -- L E F T -- P A N E L --
        surface.SetMaterial(leftpanelMat)
        surface.DrawTexturedRect(167,127,465,539)
        -- R I G H T -- P A N E L --
        surface.SetMaterial(rightpanelMat)
        surface.DrawTexturedRect(853,274,382,373)
        -- S O L D E -- D U -- G A N G --
        surface.SetFont("Bank")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(177,681)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        -- V A L E U R --
        surface.SetFont("BankSmall")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(943,280)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop:GetValue()))
        -- P R I X --
        surface.SetTextColor(255,0,0,255)
        surface.SetTextPos(194,630)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop:GetPrice()))
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(178,135)

    local function LoadPageThree()
        remove:SetPos(178,135)

        leftpanelMat = Material("gui/gbrp/gasstation/page3/leftpanel.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page3/rightpanel.png")
        local dollar = Material("gui/gbrp/gasstation/page3/dollar.png")
        local bluecard = Material("gui/gbrp/gasstation/page3/bluecard.png")
        local cheque = Material("gui/gbrp/gasstation/page3/cheque.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            -- F R A M E --
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)
            -- L E F T -- P A N E L --
            surface.SetMaterial(leftpanelMat)
            surface.DrawTexturedRect(168,127,464,506)
            -- R I G H T -- P A N E L --
            surface.SetMaterial(rightpanelMat)
            surface.DrawTexturedRect(837,256,382,373)

            surface.SetMaterial(dollar)
            surface.DrawTexturedRect(692,306,83,320)

            surface.SetMaterial(bluecard)
            surface.DrawTexturedRect(1030,156,191,69)

            surface.SetMaterial(cheque)
            surface.DrawTexturedRect(837,156,191,69)
            -- S O L D E -- D U -- J O U E U R --
            surface.SetFont("Bank")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(177,681)
            surface.DrawText("VOTRE SOLDE: " .. gbrp.formatMoney(ply:GetBalance()))
        end
        local food = {
            [1] =   {name = "mre",            y = 195},
            [2] =   {name = "beefstew",       y = 236},
            [3] =   {name = "beefstew_family",y = 277},
            [4] =   {name = "canned_fish",    y = 317},
            [5] =   {name = "peas",           y = 357},
            [6] =   {name = "squash",         y = 396},
            [7] =   {name = "hotrod",         y = 443},
            [8] =   {name = "juice",          y = 488},
            [9] =   {name = "oatmeal",        y = 531},
            [10] =  {name = "water",          y = 574}
        }
        local bill = 0
        local pretext = ""
        for k = 1,(10 - #tostring(bill)) do
            pretext = pretext .. " "
        end
        local shoppingBasket = ""
        local billLabel = vgui.Create("DLabel",frame)
        billLabel:SetFont("Bank")
        billLabel:SetText( pretext .. "$" .. tostring(bill))
        billLabel:SetTextColor(Color(0,0,0))
        billLabel:SetPos(1030,258)
        billLabel:SizeToContents()
        for k,v in pairs(food) do
            v.button = vgui.Create("DButton",frame)
            v.button:SetSize(71,28)
            v.button:SetPos(482,v.y)
            function v.button:Paint(w,h)
                if self:IsHovered() then
                    return GWEN.CreateTextureBorder(480,32,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,0,30,179))
                end
                GWEN.CreateTextureBorder(480,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,0,30,102))
            end
            function v.button:DoClick()
                shoppingBasket = v.name
                pretext = ""
                for key = 1,(10 - #tostring(bill)) do
                    pretext = pretext .. " "
                end
                billLabel:SetText( pretext .. "$" .. tostring(gbrp.foods[v.name].price))
                billLabel:SizeToContents()
            end
            v.button:SetText(gbrp.formatMoney(gbrp.foods[v.name].price))
            v.button:SetFont("Trebuchet24")
            v.button:SetColor(Color(0,0,0))
        end

        local confirm = vgui.Create("GBRPButton",frame)
        confirm.mat = Material("gui/gbrp/gasstation/page3/confirm.png")
        confirm.hoveredMat = Material("gui/gbrp/gasstation/page3/confirmrollover.png")
        confirm:SetPos(1094,422)
        confirm:SetSize(112,202)
        function confirm:DoClick()
            if shoppingBasket == "" then GAMEMODE:AddNotify("Veuillez sélectionner un article.",1,2) return end
            if ply:CanAfford(bill) then
                frame:Remove()
                net.Start("GBRP::buyfood")
                net.WriteString(shoppingBasket)
                net.SendToServer()
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    local function LoadPageTwo()
        local dropcash = vgui.Create("DropCashButton",frame)
        dropcash.mat = Material("gui/gbrp/jewelrystore/dropcash.png")
        dropcash.hoveredMat = Material("gui/gbrp/jewelrystore/dropcashrollover.png")
        dropcash:SetSize(321,105)
        dropcash:SetPos(817,181)

        local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
        withdraw.mat = Material("gui/gbrp/jewelrystore/withdraw.png")
        withdraw.hoveredMat = Material("gui/gbrp/jewelrystore/withdrawrollover.png")
        withdraw:SetSize(321,105)
        withdraw:SetPos(817,315)

        local sell = vgui.Create("SellShopButton",frame)
        sell.mat = Material("gui/gbrp/jewelrystore/sell.png")
        sell.hoveredMat = Material("gui/gbrp/jewelrystore/sellrollover.png")
        sell:SetSize(321,105)
        sell:SetPos(817,447)

        remove:SetPos(786,101)

        local shopaccess = vgui.Create("GBRPButton",frame)
        shopaccess.mat = Material("gui/gbrp/gasstation/page2/shopaccess.png")
        shopaccess.hoveredMat = Material("gui/gbrp/gasstation/page2/shopaccessrollover.png")
        shopaccess:SetPos(226,169)
        shopaccess:SetSize(421,260)
        function shopaccess:DoClick()
            self:Remove()
            dropcash:Remove()
            withdraw:Remove()
            sell:Remove()
            LoadPageThree()
        end
        local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
        local shopbalMat = Material("gui/gbrp/gasstation/page2/shopbal.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page2/rightpanel.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(rightpanelMat)
            surface.DrawTexturedRect(776,93,465,539)

            surface.SetFont("Bank")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(177,681)
            if ply:IsGangLeader() then
                surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
            else
                surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
            end

            surface.SetMaterial(shopbalMat)
            surface.DrawTexturedRect(174,548,321,68)

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(285,587)
            surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(174,637,1053,27)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(174,637,1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2), 27)

            surface.SetFont("Bank")
            surface.SetTextPos(616,563)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,0,0,255)
            surface.SetTextPos(836,601)
            surface.DrawText(gbrp.formatMoney(shop:GetValue()))
        end
    end

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(853,129)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea.mat = Material("gui/gbrp/gasstation/page1/customerarea.png")
    customerArea.hoveredMat = Material("gui/gbrp/gasstation/page1/customerarearollover.png")
    customerArea:SetSize(125,496)
    customerArea:SetPos(670,129)
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            LoadPageTwo()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::gunshopReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local panel = Material("gui/gbrp/gunshop/page1/panel.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetPos(376,137)
    frame:SetSize(1220,943)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/gunshop/frame.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(panel)
        surface.DrawTexturedRect(34,62,1132,608)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(93,670)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

        surface.SetFont("BankSmall")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(661,627)
        surface.DrawText("PRIX : " .. gbrp.formatMoney(shop:GetPrice()))

        surface.SetFont("BankSmall")
        surface.SetTextColor(255,0,0)
        surface.SetTextPos(917,627)
        surface.DrawText("REVENTE : " .. gbrp.formatMoney(shop:GetValue()))
    end

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(149,210)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1119,76)

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea.mat = Material("gui/gbrp/jewelrystore/customerarea.png")
    customerArea.hoveredMat = Material("gui/gbrp/jewelrystore/customerarearollover.png")
    customerArea:SetSize(369,126)
    customerArea:SetPos(656,211)
    local function LoadPageThree()
        local urlbar = Material("gui/gbrp/gunshop/page2/urlbar.png")
        local sidebar = Material("gui/gbrp/gunshop/page3/sidebar.png")
        local quickguns = Material("gui/gbrp/gunshop/page2/quickguns.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(urlbar)
            surface.DrawTexturedRect(34,62,1132,52)

            surface.SetMaterial(sidebar)
            surface.DrawTexturedRect(1136,114,30,555)

            surface.SetMaterial(quickguns)
            surface.DrawTexturedRect(569,250,97,284)

            surface.SetDrawColor(162,8,8,230)
            surface.DrawRect(120,127,956,89)

            surface.SetDrawColor(0,0,0,178)
            surface.DrawRect(120,216,956,351)

            surface.SetDrawColor(0,0,0,178)
            surface.DrawRect(120,587,468,44)

            surface.SetDrawColor(0,0,0,178)
            surface.DrawRect(607,587,332,44)

            surface.SetFont("BankLarge")
            surface.SetTextColor(255,255,255,166)
            surface.SetTextPos(461,144)
            surface.DrawText("A  R  M  U  R  E  R  I  E")

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0)
            surface.SetTextPos(93,670)
            surface.DrawText("VOTRE SOLDE: " .. gbrp.formatMoney(ply:GetBalance()))
        end

        local wep = {
            [1] = {classname = "weapon_breachingcharge",x = 152,    y = 230,    name = "C4",                price = 2500},
            [2] = {classname = "arccw_go_nade_smoke",   x = 168,    y = 298,    name = "M5210 Smoke",       price = 2500},
            [3] = {classname = "arccw_go_nade_molotov", x = 146,    y = 383,    name = "Coktail Molotov",   price = 2500},
            [4] = {classname = "arccw_go_nade_frag",    x = 157,    y = 491,    name = "M67 FRAG",          price = 2500},
            [5] = {classname = "arccw_bo2_fnp45",       x = 292,    y = 230,    name = "FNP-45",            price = 2500},
            [6] = {classname = "arccw_bo2_kard",        x = 416,    y = 230,    name = "TDI Kard",          price = 2500},
            [7] = {classname = "arccw_bo2_xpr50",       x = 888,    y = 229,    name = "XPR-50",            price = 2500},
            [8] = {classname = "arccw_bo2_scorpion",    x = 259,    y = 306,    name = "Scorpion Evo 3",    price = 2500},
            [9] = {classname = "arccw_bo2_s12",         x = 889,    y = 479,    name = "Saiga 12K",         price = 2500},
            [10] = {classname = "arccw_bo2_ksg",        x = 672,    y = 479,    name = "KSG",               price = 2500},
            [11] = {classname = "arccw_bo2_type95",     x = 669,    y = 298,    name = "QBZ-95-1",          price = 2500},
            [12] = {classname = "arccw_bo2_msmc",       x = 258,    y = 494,    name = "JPVC",              price = 2500},
            [13] = {classname = "arccw_bo2_pdw57",      x = 416,    y = 306,    name = "PDW-57",            price = 2500},
            [14] = {classname = "arccw_waw_thompson",   x = 409,    y = 490,    name = "Thompson",          price = 2500},
            [15] = {classname = "arccw_bo2_mtar",       x = 413,    y = 406,    name = "MTAR-21",           price = 5000},
            [16] = {classname = "arccw_bo2_mp7",        x = 289,    y = 401,    name = "HK MP7 A1",         price = 2500},
            [17] = {classname = "arccw_bo2_m27",        x = 668,    y = 388,    name = "HK-416",            price = 2500},
            [18] = {classname = "arccw_bo2_scarh",      x = 891,    y = 388,    name = "FN SCAR-H",         price = 2500},
            [19] = {classname = "arccw_bo2_osw",        x = 667,    y = 230,    name = "DSA SA 58",         price = 10000},
            [20] = {classname = "arccw_bo2_an94",       x = 887,    y = 298,    name = "AN-94",             price = 2500},
        }
        local selected = nil
        for k,v in pairs(wep) do
            v.button = vgui.Create("DImageButton",frame)
            v.button:SetPos(v.x,v.y)
            v.button:SetImage("gui/gbrp/gunshop/page3/" .. v.classname .. ".png")
            v.button:SizeToContents()

            v.label = vgui.Create("DLabel",frame)
            v.label:SetColor(Color(255,255,255,255))
            v.label:SetFont("CloseCaption_BoldItalic")
            v.label:SetText(v.name)
            v.label:SizeToContents()
            v.label:SetSize(v.label:GetWide() + 5,v.label:GetTall())
            v.label:SetPos(354 - v.label:GetWide() / 2,595)
            v.label:SetVisible(false)

            v.priceLabel = vgui.Create("DLabel",frame)
            v.priceLabel:SetColor(Color(255,0,0,255))
            v.priceLabel:SetFont("BankLarge")
            v.priceLabel:SetText(gbrp.formatMoney(v.price))
            v.priceLabel:SizeToContents()
            v.priceLabel:SetPos(773 - v.priceLabel:GetWide() / 2,583)
            v.priceLabel:SetVisible(false)
            function v.button:OnCursorEntered()
                if selected then
                    selected.label:SetVisible(false)
                    selected.priceLabel:SetVisible(false)
                end
                self:SetColor(Color(255,0,0,255))
                v.label:SetVisible(true)
                v.priceLabel:SetVisible(true)
            end
            function v.button:OnCursorExited()
                if selected == v then return end
                self:SetColor(Color(255,255,255,255))
                v.label:SetVisible(false)
                v.priceLabel:SetVisible(false)
                if selected then
                    selected.button:SetColor(Color(255,0,0,255))
                    selected.label:SetVisible(true)
                    selected.priceLabel:SetVisible(true)
                end
            end
            function v.button:DoClick()
                if selected then
                    selected.button:SetColor(Color(255,255,255,255))
                end
                selected = v
            end
        end

        local payer = vgui.Create("GBRPButton",frame)
        payer.mat = Material("gui/gbrp/gunshop/page3/payer.png")
        payer.hoveredMat = Material("gui/gbrp/gunshop/page3/payerrollover.png")
        payer:SetSize(119,44)
        payer:SetPos(956,587)
        function payer:DoClick()
            if not selected then GAMEMODE:AddNotify("Veuillez sélectionner un article.",1,2) return end
            if ply:CanAfford(selected.price) then
                frame:Remove()
                net.Start("GBRP::buywep")
                net.WriteString(selected.classname)
                net.WriteInt(selected.price,7)
                net.SendToServer()
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    local function LoadPageTwo()
        local urlbar = Material("gui/gbrp/gunshop/page2/urlbar.png")
        local sidebar = Material("gui/gbrp/gunshop/page2/sidebar.png")
        local ar15 = Material("gui/gbrp/gunshop/page2/ar15.png")
        local quickguns = Material("gui/gbrp/gunshop/page2/quickguns.png")
        local balanceMat = Material("gui/gbrp/gunshop/page2/balance.png")
        local valueMat = Material("gui/gbrp/gunshop/page2/value.png")
        local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(urlbar)
            surface.DrawTexturedRect(34,62,1132,52)

            surface.SetMaterial(sidebar)
            surface.DrawTexturedRect(1136,114,42,563)

            surface.SetMaterial(ar15)
            surface.DrawTexturedRect(97,176,319,68)

            surface.SetMaterial(quickguns)
            surface.DrawTexturedRect(556,207,97,284)

            surface.SetMaterial(balanceMat)
            surface.DrawTexturedRect(96,371,321,68)

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(213,408)
            surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

            surface.SetMaterial(valueMat)
            surface.DrawTexturedRect(96,465,321,68)

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(213,502)
            surface.DrawText(gbrp.formatMoney(shop:GetValue()))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(66,620,1053,27)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(66,620,1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2), 27)

            surface.SetFont("BankLarge")
            surface.SetTextPos(563,569)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0)
            surface.SetTextPos(93,670)
            if ply:IsGangLeader() then
                surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
            else
                surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
            end
        end

        local dropcash = vgui.Create("DropCashButton",frame)
        dropcash.mat = Material("gui/gbrp/gunshop/page2/dropcash.png")
        dropcash.hoveredMat = Material("gui/gbrp/gunshop/page2/dropcashrollover.png")
        dropcash:SetSize(321,105)
        dropcash:SetPos(722,176)

        local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
        withdraw.mat = Material("gui/gbrp/gunshop/page2/withdraw.png")
        withdraw.hoveredMat = Material("gui/gbrp/gunshop/page2/withdrawrollover.png")
        withdraw:SetSize(321,105)
        withdraw:SetPos(722,310)

        local sell = vgui.Create("SellShopButton",frame)
        sell.mat = Material("gui/gbrp/jewelrystore/sell.png")
        sell.hoveredMat = Material("gui/gbrp/jewelrystore/sellrollover.png")
        sell:SetSize(321,105)
        sell:SetPos(722,442)

        local entershop = vgui.Create("GBRPButton",frame)
        entershop.mat = Material("gui/gbrp/gunshop/page2/entershop.png")
        entershop.hoveredMat = Material("gui/gbrp/gunshop/page2/entershoprollover.png")
        entershop:SetSize(320,68)
        entershop:SetPos(96,271)
        function entershop:DoClick()
            self:Remove()
            sell:Remove()
            withdraw:Remove()
            dropcash:Remove()
            LoadPageThree()
        end
    end
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            LoadPageTwo()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::repairgarageReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local urlbar = Material("gui/gbrp/repairgarage/urlbar.jpg")
    local background = Material("gui/gbrp/repairgarage/background.jpg")
    local sidebar = Material("gui/gbrp/sidebar.png")
    local bottombar = Material("gui/gbrp/bottombar.jpg")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetPos(376,143)
    frame:SetSize(1220,937)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/pcscreen.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(urlbar)
        surface.DrawTexturedRect(34,58,1133,50)

        surface.SetFont("BankSmall")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(483,70)
        surface.DrawText("www.mecano-auto.fr")

        surface.SetMaterial(background)
        surface.DrawTexturedRect(34,108,1106,555)

        surface.SetMaterial(sidebar)
        surface.DrawTexturedRect(1136,108,31,555)

        surface.SetMaterial(bottombar)
        surface.DrawTexturedRect(36,663,1131,41)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(94,664)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
    end
    local price = vgui.Create("DImage",frame)
    price:SetPos(183,472)
    price:SetSize(377,53)
    price:SetMaterial("gui/gbrp/repairgarage/page1/price.png")
    local priceLabel = vgui.Create("DLabel",price)
    priceLabel:SetFont("Bank")
    priceLabel:SetColor(Color(255,255,255,255))
    priceLabel:SetText("PRIX : " .. gbrp.formatMoney(shop:GetPrice()))
    priceLabel:SizeToContents()
    priceLabel:Center()

    local value = vgui.Create("DImage",frame)
    value:SetPos(634,472)
    value:SetSize(377,53)
    value:SetMaterial("gui/gbrp/repairgarage/page1/value.png")
    local valueLabel = vgui.Create("DLabel",value)
    valueLabel:SetFont("Bank")
    valueLabel:SetColor(Color(255,0,0,255))
    valueLabel:SetText("VENTE : " .. gbrp.formatMoney(shop:GetValue()))
    valueLabel:SizeToContents()
    valueLabel:Center()

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(183,346)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1115,69)

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea.mat = Material("gui/gbrp/jewelrystore/customerarea.png")
    customerArea.hoveredMat = Material("gui/gbrp/jewelrystore/customerarearollover.png")
    customerArea:SetSize(369,126)
    customerArea:SetPos(634,346)
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            price:Remove()
            value:Remove()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
            local balanceMat = Material("gui/gbrp/gunshop/page2/balance.png")
            local valueMat = Material("gui/gbrp/gunshop/page2/value.png")
            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetMaterial(urlbar)
                surface.DrawTexturedRect(34,58,1133,50)

                surface.SetFont("BankSmall")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(483,70)
                surface.DrawText("www.mec-à-nique.fr")

                surface.SetMaterial(background)
                surface.DrawTexturedRect(34,108,1106,555)

                surface.SetMaterial(sidebar)
                surface.DrawTexturedRect(1136,108,31,555)

                surface.SetMaterial(bottombar)
                surface.DrawTexturedRect(36,663,1131,41)

                surface.SetMaterial(valueMat)
                surface.DrawTexturedRect(57,121,321,68)

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0)
                surface.SetTextPos(173,155)
                surface.DrawText(gbrp.formatMoney(shop:GetValue()))

                surface.SetMaterial(balanceMat)
                surface.DrawTexturedRect(795,121,321,68)

                surface.SetTextColor(255,255,255)
                surface.SetTextPos(907,155)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(66,394,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(66,394,1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2), 27)

                surface.SetFont("BankLarge")
                surface.SetTextPos(561,338)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(94,664)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end
            end

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash.mat = Material("gui/gbrp/gunshop/page2/dropcash.png")
            dropcash.hoveredMat = Material("gui/gbrp/gunshop/page2/dropcashrollover.png")
            dropcash:SetSize(321,105)
            dropcash:SetPos(66,470)

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw.mat = Material("gui/gbrp/gunshop/page2/withdraw.png")
            withdraw.hoveredMat = Material("gui/gbrp/gunshop/page2/withdrawrollover.png")
            withdraw:SetPos(432,470)
            withdraw:SetSize(321,105)

            local sell = vgui.Create("SellShopButton",frame)
            sell.mat = Material("gui/gbrp/repairgarage/page2/sell.png")
            sell.hoveredMat = Material("gui/gbrp/jewelrystore/sellrollover.png")
            sell:SetPos(801,470)
            sell:SetSize(321,105)
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::drugstoreReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local urlbar = Material("gui/gbrp/macbook/urlbar.jpg")
    local background = Material("gui/gbrp/drugstore/page1/background.jpg")
    local bottombar = Material("gui/gbrp/macbook/bottombar.jpg")
    local logo = Material("gui/gbrp/drugstore/logo.png")
    local panel = Material("gui/gbrp/drugstore/page1/panel.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1217,964)
    frame:CenterHorizontal()
    frame:SetY(ScrH() - 964)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/macbook/screen.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(urlbar)
        surface.DrawTexturedRect(41,42,1132,40)

        surface.SetFont("BankSmall")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(517,50)
        surface.DrawText("www.rdv-dispistage-coco.com")

        surface.SetMaterial(background)
        surface.DrawTexturedRect(45,82,1127,564)

        surface.SetMaterial(bottombar)
        surface.DrawTexturedRect(44,646,1129,33)

        surface.SetMaterial(logo)
        surface.DrawTexturedRect(588,752,52,48)

        surface.SetMaterial(panel)
        surface.DrawTexturedRect(734,98,403,531)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(93,644)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

        surface.SetFont("BankSmall")
        surface.SetTextPos(906,326)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop:GetValue()))

        surface.SetFont("BankSmall")
        surface.SetTextColor(255,0,0)
        surface.SetTextPos(906,296)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop:GetPrice()))
    end

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(182,206)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1112,48)

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea.mat = Material("gui/gbrp/jewelrystore/customerarea.png")
    customerArea.hoveredMat = Material("gui/gbrp/jewelrystore/customerarearollover.png")
    customerArea:SetSize(369,126)
    customerArea:SetPos(182,413)
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
            local balanceMat = Material("gui/gbrp/drugstore/page2/balance.png")
            local valueMat = Material("gui/gbrp/drugstore/page2/value.png")
            background = Material("gui/gbrp/drugstore/page2/background.jpg")
            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetMaterial(background)
                surface.DrawTexturedRect(45,81,1127,565)

                surface.SetMaterial(urlbar)
                surface.DrawTexturedRect(41,42,1132,40)

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,255,255)
                surface.SetTextPos(517,50)
                surface.DrawText("www.pharmagouille.com")

                surface.SetMaterial(bottombar)
                surface.DrawTexturedRect(44,646,1129,33)

                surface.SetMaterial(valueMat)
                surface.DrawTexturedRect(84,422,320,68)

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0)
                surface.SetTextPos(195,456)
                surface.DrawText(gbrp.formatMoney(shop:GetValue()))

                surface.SetMaterial(balanceMat)
                surface.DrawTexturedRect(84,319,320,68)

                surface.SetTextColor(255,255,255)
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(195,353)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(80,593,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(80,593,1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2), 27,Color(0,255,0,255))

                surface.SetFont("BankLarge")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(575,544)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(93,644)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end
            end

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash.mat = Material("gui/gbrp/gunshop/page2/dropcash.png")
            dropcash.hoveredMat = Material("gui/gbrp/gunshop/page2/dropcashrollover.png")
            dropcash:SetSize(321,105)
            dropcash:SetPos(83,166)

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw.mat = Material("gui/gbrp/gunshop/page2/withdraw.png")
            withdraw.hoveredMat = Material("gui/gbrp/gunshop/page2/withdrawrollover.png")
            withdraw:SetPos(448,166)
            withdraw:SetSize(321,105)

            local sell = vgui.Create("SellShopButton",frame)
            sell.mat = Material("gui/gbrp/jewelrystore/sell.png")
            sell.hoveredMat = Material("gui/gbrp/jewelrystore/sellrollover.png")
            sell:SetPos(816,166)
            sell:SetSize(321,105)

            local heal = vgui.Create("GBRPButton",frame)
            heal.mat = Material("gui/gbrp/drugstore/page2/heal.png")
            heal.hoveredMat = Material("gui/gbrp/drugstore/page2/healrollover.png")
            heal:SetPos(816,373)
            heal:SetSize(321,68)
            heal.DoClick = function()
                if not ply.LastTimeHealed or CurTime() - ply.LastTimeHealed >= 420 then
                    ply.LastTimeHealed = CurTime()
                    net.Start("GBRP::heal")
                    net.SendToServer()
                elseif CurTime() - ply.LastTimeHealed < 420 then
                    GAMEMODE:AddNotify("Il vous faut attendre " .. tostring(math.Round(420 - CurTime() + ply.LastTimeHealed)) .. " secondes.",1,2)
                end
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::barReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame.mat = Material("gui/gbrp/bar/frame.png")
    frame.shop = shop
    frame:SetPos(266,164)
    frame:SetSize(1396,716)
    frame:MakePopup()
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetDrawColor(0,0,0,127)
        surface.DrawRect(124,529,1119,112)

        surface.SetTextColor(255,255,255,255)
        surface.SetFont("BankSmall")
        surface.SetTextPos(521,562)
        surface.DrawText("PASSIF : Le bar vous permet de ne pas perdre d'argent lors de sa cession.")

        surface.SetFont("Bank")
        surface.SetTextPos(140,600)
        surface.DrawText("PRIX : " .. gbrp.formatMoney(shop:GetPrice()))

        surface.SetTextColor(255,0,0)
        surface.SetTextPos(140,561)
        surface.DrawText("REVENTE : " .. gbrp.formatMoney(shop:GetValue()))

        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(166,640)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(586,46)
        surface.SetFont("BankSmall")
        surface.DrawText("www.nul-bar-ailleurs.com")
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1189,44)

    local buy = vgui.Create("Button",frame)
    buy:SetSize(369,126)
    buy:SetPos(310,142)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local customerarea = vgui.Create("GBRPButton",frame)
    customerarea.mat = Material("gui/gbrp/jewelrystore/customerarea.png")
    customerarea.hoveredMat = Material("gui/gbrp/jewelrystore/customerarearollover.png")
    customerarea:SetSize(369,126)
    customerarea:SetPos(750,142)
    function customerarea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            local balance = Material("gui/gbrp/club/shopbal.png")
            local value = Material("gui/gbrp/club/shopval.png")
            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetTextColor(255,255,255,255)
                surface.SetTextPos(616,46)
                surface.SetFont("BankSmall")
                surface.DrawText("www.esc-ô-bar.com")

                surface.SetMaterial(balance)
                surface.DrawTexturedRect(311,485,321,68)

                surface.SetMaterial(value)
                surface.DrawTexturedRect(755,485,321,68)

                surface.SetTextColor(0,0,0,255)
                surface.SetFont("Bank")
                surface.SetTextPos(166,640)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end

                surface.SetFont("BankSmall")
                surface.SetTextPos(422,519)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(879,519)
                surface.DrawText(gbrp.formatMoney(shop:GetValue()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(157,381,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(157,381,1053 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2), 27)

                surface.SetFont("Bank")
                surface.SetTextColor(255,255,255,255)
                surface.SetTextPos(680,333)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")
            end

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash.mat = Material("gui/gbrp/jewelrystore/dropcash.png")
            dropcash.hoveredMat = Material("gui/gbrp/jewelrystore/dropcashrollover.png")
            dropcash:SetSize(321,105)
            dropcash:SetPos(156,162)

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw.mat = Material("gui/gbrp/jewelrystore/withdraw.png")
            withdraw.hoveredMat = Material("gui/gbrp/jewelrystore/withdrawrollover.png")
            withdraw:SetSize(321,105)
            withdraw:SetPos(521,162)

            local sell = vgui.Create("SellShopButton",frame)
            sell.mat = Material("gui/gbrp/bar/sell.png")
            sell.hoveredMat = Material("gui/gbrp/bar/sellrollover.png")
            sell:SetSize(321,105)
            sell:SetPos(889,162)
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

end)
net.Receive("GBRP::welcomeScreen",function()
    local selected
    local leaderlabel
    local memberlabel
    local archilabel
    local mediclabel
    local label
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(gbrp.ScreenW,gbrp.ScreenH)
    frame.mat = Material("gui/gbrp/welcomescreen/background1.jpg")
    frame:MakePopup()
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
    end

    local continuer = vgui.Create("GBRPButton",frame)
    continuer.mat = Material("gui/gbrp/welcomescreen/page1/continuer.png")
    continuer.hoveredMat = Material("gui/gbrp/welcomescreen/page1/continuerrollover.png")
    continuer:SetPos(gbrp.FormatXY(655,902))
    continuer:SetSize(gbrp.FormatXY(572,26))
    local LoadPage3 = {}

    LoadPage3.init = function()
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetDrawColor(0,0,0,90)
            surface.DrawRect(0,gbrp.FormatY(442),gbrp.ScreenW,gbrp.FormatY(644))
        end
        label:SetText("CHOIX DU METIER:")
        label:SizeToContents()
        label:CenterHorizontal(.5)
        label:CenterVertical(.1)
        leaderlabel = vgui.Create("DImage",frame)
        leaderlabel:SetImage("gui/gbrp/welcomescreen/page3/leaderlabel.png")
        leaderlabel:SetVisible(false)
        leaderlabel:SetPos(gbrp.FormatXY(40,257))
        leaderlabel:SetSize(gbrp.FormatXY(430,176))
        memberlabel = vgui.Create("DImage",frame)
        memberlabel:SetImage("gui/gbrp/welcomescreen/page3/memberlabel.png")
        memberlabel:SetVisible(false)
        memberlabel:SetPos(gbrp.FormatXY(512,257))
        memberlabel:SetSize(gbrp.FormatXY(430,176))
        archilabel = vgui.Create("DImage",frame)
        archilabel:SetImage("gui/gbrp/welcomescreen/page3/archilabel.png")
        archilabel:SetPos(gbrp.FormatXY(1002,257))
        archilabel:SetSize(gbrp.FormatXY(430,176))
        archilabel:SetVisible(false)
        mediclabel = vgui.Create("DImage",frame)
        mediclabel:SetImage("gui/gbrp/welcomescreen/page3/mediclabel.png")
        mediclabel:SetPos(gbrp.FormatXY(1483,257))
        mediclabel:SetSize(gbrp.FormatXY(430,176))
        mediclabel:SetVisible(false)
    end

    LoadPage3.yakuzas = function()
        local yakuleader = vgui.Create("DImageButton",frame)
        yakuleader.jobtable,yakuleader.teamid = DarkRP.getJobByCommand("yakuleader")
        if team.NumPlayers(yakuleader.teamid) >= yakuleader.jobtable.max then
            yakuleader:SetImage("gui/gbrp/welcomescreen/page3/yakuleader.png")
            yakuleader:SetPos(gbrp.FormatXY(134,341))
            yakuleader:SetSize(gbrp.FormatXY(247,711))
        else
            yakuleader:SetImage("gui/gbrp/welcomescreen/page3/yakuleaderavailable.png")
            yakuleader:SetPos(gbrp.FormatXY(100,309))
            yakuleader:SetSize(gbrp.FormatXY(314,777))
            yakuleader.available = true
        end
        yakuleader.OnCursorEntered = function()
            leaderlabel:SetVisible(true)
        end
        yakuleader.OnCursorExited = function()
            leaderlabel:SetVisible(false)
        end
        local yakumember = vgui.Create("DImageButton",frame)
        yakumember:SetImage("gui/gbrp/welcomescreen/page3/yakuavailable.png")
        yakumember:SetPos(gbrp.FormatXY(595,419))
        yakumember:SetSize(gbrp.FormatXY(283,676))
        yakumember.OnCursorEntered = function()
            memberlabel:SetVisible(true)
        end
        yakumember.OnCursorExited = function()
            memberlabel:SetVisible(false)
        end
        local yakuarchi = vgui.Create("DImageButton",frame)
        yakuarchi.jobtable,yakuarchi.teamid = DarkRP.getJobByCommand("yakuarchi")
        if team.NumPlayers(yakuarchi.teamid) >= yakuarchi.jobtable.max then
            yakuarchi:SetImage("gui/gbrp/welcomescreen/page3/yakuarchi.png")
            yakuarchi:SetPos(gbrp.FormatXY(1058,448))
            yakuarchi:SetSize(gbrp.FormatXY(255,598))
        else
            yakuarchi:SetImage("gui/gbrp/welcomescreen/page3/yakuarchiavailable.png")
            yakuarchi:SetPos(gbrp.FormatXY(1024,415))
            yakuarchi:SetSize(gbrp.FormatXY(324,665))
            yakuarchi.available = true
        end
        yakuarchi.OnCursorEntered = function()
            archilabel:SetVisible(true)
        end
        yakuarchi.OnCursorExited = function()
            archilabel:SetVisible(false)
        end
        local yakumedic = vgui.Create("DImageButton",frame)
        yakumedic.jobtable,yakumedic.teamid = DarkRP.getJobByCommand("yakumedic")
        if team.NumPlayers(yakumedic.teamid) >= yakumedic.jobtable.max then
            yakumedic:SetImage("gui/gbrp/welcomescreen/page3/yakumedic.png")
            yakumedic:SetPos(gbrp.FormatX(1584),gbrp.FormatY(453))
            yakumedic:SetSize(gbrp.FormatX(229),gbrp.FormatY(623))
        else
            yakumedic:SetImage("gui/gbrp/welcomescreen/page3/yakumedicavailable.png")
            yakumedic:SetPos(gbrp.FormatX(1548),gbrp.FormatY(418))
            yakumedic:SetSize(gbrp.FormatX(299),gbrp.FormatY(693))
            yakumedic.available = true
        end
        yakumedic.OnCursorEntered = function()
            mediclabel:SetVisible(true)
        end
        yakumedic.OnCursorExited = function()
            mediclabel:SetVisible(false)
        end
        function yakuleader:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /yakuleader")
            end
        end
        function yakumember:DoClick()
            frame:Remove()
            LocalPlayer():ConCommand("say /yaku")
        end
        function yakuarchi:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /yakuarchi")
            end
        end
        function yakumedic:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /yakumedic")
            end
        end
    end

    LoadPage3.mafia = function()
        local mafialeader = vgui.Create("DImageButton",frame)
        mafialeader.jobtable,mafialeader.teamid = DarkRP.getJobByCommand("mafiamedic")
        if team.NumPlayers(mafialeader.teamid) >= mafialeader.jobtable.max then
            mafialeader:SetImage("gui/gbrp/welcomescreen/page3/mafialeader.png")
            mafialeader:SetPos(gbrp.FormatX(181),gbrp.FormatY(472))
            mafialeader:SetSize(gbrp.FormatX(199),gbrp.FormatY(608))
        else
            mafialeader:SetImage("gui/gbrp/welcomescreen/page3/mafialeaderavailable.png")
            mafialeader:SetPos(gbrp.FormatX(146),gbrp.FormatY(437))
            mafialeader:SetSize(gbrp.FormatX(269),gbrp.FormatY(677))
            mafialeader.available = true
        end
        mafialeader.OnCursorEntered = function()
            leaderlabel:SetVisible(true)
        end
        mafialeader.OnCursorExited = function()
            leaderlabel:SetVisible(false)
        end
        local mafiamember = vgui.Create("DImageButton",frame)
        mafiamember.jobtable,mafiamember.teamid = DarkRP.getJobByCommand("mafia")
        mafiamember:SetImage("gui/gbrp/welcomescreen/page3/mafiaavailable.png")
        mafiamember:SetPos(gbrp.FormatX(535),gbrp.FormatY(466))
        mafiamember:SetSize(gbrp.FormatX(442),gbrp.FormatY(641))
        mafiamember.OnCursorEntered = function()
            memberlabel:SetVisible(true)
        end
        mafiamember.OnCursorExited = function()
            memberlabel:SetVisible(false)
        end
        local mafiaarchi = vgui.Create("DImageButton",frame)
        mafiaarchi.jobtable,mafiaarchi.teamid = DarkRP.getJobByCommand("mafiaarchi")
        if team.NumPlayers(mafiaarchi.teamid) >= mafiaarchi.jobtable.max then
            mafiaarchi:SetImage("gui/gbrp/welcomescreen/page3/mafiaarchi.png")
            mafiaarchi:SetPos(gbrp.FormatX(1130),gbrp.FormatY(471))
            mafiaarchi:SetSize(gbrp.FormatX(189),gbrp.FormatY(601))
        else
            mafiaarchi:SetImage("gui/gbrp/welcomescreen/page3/mafiaarchiavailable.png")
            mafiaarchi:SetPos(gbrp.FormatX(1095),gbrp.FormatY(435))
            mafiaarchi:SetSize(gbrp.FormatX(260),gbrp.FormatY(673))
            mafiaarchi.available = true
        end
        mafiaarchi.OnCursorEntered = function()
            archilabel:SetVisible(true)
        end
        mafiaarchi.OnCursorExited = function()
            archilabel:SetVisible(false)
        end
        local mafiamedic = vgui.Create("DImageButton",frame)
        mafiamedic.jobtable,mafiamedic.teamid = DarkRP.getJobByCommand("mafiamedic")
        if team.NumPlayers(mafiamedic.teamid) >= mafiamedic.jobtable.max then
            mafiamedic:SetImage("gui/gbrp/welcomescreen/page3/mafiamedic.png")
            mafiamedic:SetPos(gbrp.FormatX(1584),gbrp.FormatY(480))
            mafiamedic:SetSize(gbrp.FormatX(229),gbrp.FormatY(606))
        else
            mafiamedic:SetImage("gui/gbrp/welcomescreen/page3/mafiamedicavailable.png")
            mafiamedic:SetPos(gbrp.FormatX(1549),gbrp.FormatY(445))
            mafiamedic:SetSize(gbrp.FormatX(300),gbrp.FormatY(675))
            mafiamedic.available = true
        end
        mafiamedic.OnCursorEntered = function()
            mediclabel:SetVisible(true)
        end
        mafiamedic.OnCursorExited = function()
            mediclabel:SetVisible(false)
        end
        function mafialeader:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /mafialeader")
            end
        end
        function mafiamember:DoClick()
            frame:Remove()
            LocalPlayer():ConCommand("say /mafia")
        end
        function mafiaarchi:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /mafiaarchi")
            end
        end
        function mafiamedic:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /mafiamedic")
            end
        end
    end

    LoadPage3.gang = function()
        local gangleader = vgui.Create("DImageButton",frame)
        gangleader.jobtable,gangleader.teamid = DarkRP.getJobByCommand("gangmedic")
        if team.NumPlayers(gangleader.teamid) >= gangleader.jobtable.max then
            gangleader:SetImage("gui/gbrp/welcomescreen/page3/gangleader.png")
            gangleader:SetPos(gbrp.FormatX(160),gbrp.FormatY(460))
            gangleader:SetSize(gbrp.FormatX(287),gbrp.FormatY(618))
        else
            gangleader:SetImage("gui/gbrp/welcomescreen/page3/gangleaderavailable.png")
            gangleader:SetPos(gbrp.FormatX(125),gbrp.FormatY(425))
            gangleader:SetSize(gbrp.FormatX(357),gbrp.FormatY(689))
            gangleader.available = true
        end
        gangleader.OnCursorEntered = function()
            leaderlabel:SetVisible(true)
        end
        gangleader.OnCursorExited = function()
            leaderlabel:SetVisible(false)
        end
        local gangmember = vgui.Create("DImageButton",frame)
        gangmember.jobtable,gangmember.teamid = DarkRP.getJobByCommand("gang")
        gangmember:SetImage("gui/gbrp/welcomescreen/page3/gangavailable.png")
        gangmember:SetPos(gbrp.FormatX(570),gbrp.FormatY(421))
        gangmember:SetSize(gbrp.FormatX(299),gbrp.FormatY(683))
        gangmember.OnCursorEntered = function()
            memberlabel:SetVisible(true)
        end
        gangmember.OnCursorExited = function()
            memberlabel:SetVisible(false)
        end
        local gangarchi = vgui.Create("DImageButton",frame)
        gangarchi.jobtable,gangarchi.teamid = DarkRP.getJobByCommand("gangarchi")
        if team.NumPlayers(gangarchi.teamid) >= gangarchi.jobtable.max then
            gangarchi:SetImage("gui/gbrp/welcomescreen/page3/gangarchi.png")
            gangarchi:SetPos(gbrp.FormatX(1111),gbrp.FormatY(460))
            gangarchi:SetSize(gbrp.FormatX(199),gbrp.FormatY(638))
        else
            gangarchi:SetImage("gui/gbrp/welcomescreen/page3/gangarchiavailable.png")
            gangarchi:SetPos(gbrp.FormatX(1078),gbrp.FormatY(425))
            gangarchi:SetSize(gbrp.FormatX(267),gbrp.FormatY(708))
            gangarchi.available = true
        end
        gangarchi.OnCursorEntered = function()
            archilabel:SetVisible(true)
        end
        gangarchi.OnCursorExited = function()
            archilabel:SetVisible(false)
        end
        local gangmedic = vgui.Create("DImageButton",frame)
        gangmedic.jobtable,gangmedic.teamid = DarkRP.getJobByCommand("gangmedic")
        if team.NumPlayers(gangmedic.teamid) >= gangmedic.jobtable.max then
            gangmedic:SetImage("gui/gbrp/welcomescreen/page3/gangmedic.png")
            gangmedic:SetPos(gbrp.FormatX(1596),gbrp.FormatY(470))
            gangmedic:SetSize(gbrp.FormatX(205),gbrp.FormatY(602))
        else
            gangmedic:SetImage("gui/gbrp/welcomescreen/page3/gangmedicavailable.png")
            gangmedic:SetPos(gbrp.FormatX(1561),gbrp.FormatY(436))
            gangmedic:SetSize(gbrp.FormatX(275),gbrp.FormatY(672))
            gangmedic.available = true
        end
        gangmedic.OnCursorEntered = function()
            mediclabel:SetVisible(true)
        end
        gangmedic.OnCursorExited = function()
            mediclabel:SetVisible(false)
        end
        function gangleader:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /gangleader")
            end
        end
        function gangmember:DoClick()
            frame:Remove()
            LocalPlayer():ConCommand("say /gang")
        end
        function gangarchi:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /gangarchi")
            end
        end
        function gangmedic:DoClick()
            if self.available then
                frame:Remove()
                LocalPlayer():ConCommand("say /gangmedic")
            end
        end
    end

    local function LoadPage2()
        local gangpos = {
            [1] = {{181,460},{149,425}},
            [2] = {{648,456},{601,412}}
        }
        local bubblexpos = {
            [1] = 93,
            [2] = 555
        }
        frame.mat = Material("gui/gbrp/welcomescreen/background2.jpg")
        local gangs = gbrp.sortedGangs()
        label = vgui.Create("DLabel",frame)
        label:SetFont("Bank")
        label:SetText("Choix du gang:")
        label:SizeToContents()
        label:SetPos(gbrp.FormatX(355),gbrp.FormatY(225))
        local bubbles = {}
        local ganglabels = {}
        local gangButton = {}
        local i = 0
        for k,v in pairs(gangs) do
            i = i + 1
            bubbles[k] = vgui.Create("DImage",frame)
            bubbles[k]:SetPos(gbrp.FormatX(bubblexpos[i]),gbrp.FormatY(276))
            bubbles[k]:SetSize(gbrp.FormatX(378),gbrp.FormatY(155))
            bubbles[k]:SetImage("gui/gbrp/welcomescreen/page2/bubble.png")
            bubbles[k]:SetVisible(false)
            ganglabels[k] = vgui.Create("DLabel",bubbles[k])
            ganglabels[k]:SetFont("BankLarge")
            ganglabels[k]:SetText(string.upper(v.membername))
            ganglabels[k]:SizeToContents()
            ganglabels[k]:Center()
            ganglabels[k]:SetY(ganglabels[k]:GetY() - gbrp.FormatY(40))
            gangButton[k] = vgui.Create("DImageButton",frame)
            gangButton[k].gangName = v.name
            gangButton[k]:SetImage("gui/gbrp/welcomescreen/page2/" .. v.name .. ".png")
            gangButton[k]:SizeToContents()
            gangButton[k]:SetPos(gbrp.FormatX(gangpos[i][1][1]),gbrp.FormatY(gangpos[i][1][2]))
            gangButton[k].index = i
            gangButton[k].OnCursorEntered = function(self)
                self:SetImage("gui/gbrp/welcomescreen/page2/" .. v.name .. "rollover.png")
                self:SizeToContents()
                self:SetPos(gbrp.FormatX(gangpos[self.index][2][1]),gbrp.FormatY(gangpos[self.index][2][2]))
                bubbles[k]:SetVisible(true)
            end
            gangButton[k].Unselect = function(self)
                self:SetImage("gui/gbrp/welcomescreen/page2/" .. v.name .. ".png")
                self:SizeToContents()
                self:SetPos(gbrp.FormatX(gangpos[self.index][1][1]),gbrp.FormatY(gangpos[self.index][1][2]))
                bubbles[k]:SetVisible(false)
            end
            gangButton[k].OnCursorExited = function(self)
                if self ~= selected then
                    self:Unselect()
                end
            end
            gangButton[k].DoClick = function(self)
                if selected then selected:Unselect() end
                selected = self
            end
        end
        continuer = vgui.Create("GBRPButton",frame)
        continuer.mat = Material("gui/gbrp/welcomescreen/page2/continuer.png")
        continuer.hoveredMat = Material("gui/gbrp/welcomescreen/page2/continuerrollover.png")
        continuer:SetPos(gbrp.FormatX(1183),gbrp.FormatY(985))
        continuer:SetSize(gbrp.FormatX(215),gbrp.FormatY(34))
        continuer.DoClick = function()
            if selected then
                continuer:Remove()
                for k,v in pairs(gangs) do
                    bubbles[k]:Remove()
                    ganglabels[k]:Remove()
                    gangButton[k]:Remove()
                end
                LoadPage3.init()
                LoadPage3[selected.gangName]()
            end
        end
    end
    function continuer:DoClick()
        self:Remove()
        LoadPage2()
    end
end)
net.Receive("GBRP::laundererReception",function()
    local launderer = net.ReadEntity()
    local ply = LocalPlayer()
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(gbrp.ScreenW,gbrp.ScreenH)
    frame:MakePopup()
    local label = vgui.Create("DLabel",frame)
    label:SetFont("DermaLarge")
    label:SetText("Montant à blanchir:")
    label:SizeToContents()
    label:CenterHorizontal(.5)
    local textEntry = vgui.Create("DTextEntry",frame)
    textEntry:SetWide(label:GetWide())
    textEntry:CenterHorizontal(.5)
    textEntry:CenterVertical(.5)
    label:SetY(textEntry:GetY() - textEntry:GetTall() - 20)
    textEntry:RequestFocus()
    function textEntry:OnEnter()
        local amount = tonumber(self:GetValue())
        if isnumber(amount) and amount > 0 and ply:canAfford(amount) then
            net.Start("GBRP::launderingRequest")
            net.WriteEntity(launderer)
            net.WriteInt(amount,32)
            net.SendToServer()
        else
            GAMEMODE:AddNotify("Montant invalide.",1,2)
        end
        frame:Remove()
    end
end)
net.Receive("GBRP::robberyPanel",function()
    if IsValid(frame) then return end
    local shop = net.ReadEntity()
    local ply = LocalPlayer()
    local time = Material("gui/gbrp/robbery/time.png")
    local att = Material("gui/gbrp/robbery/att.png")
    local attChar = ply:GetGang().materials[ply:GetGBRPClass()]
    local defChar = shop:GetGang().materials.leader
    local def = Material("gui/gbrp/robbery/def.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(gbrp.FormatX(989),gbrp.FormatY(979))
    frame:SetPos(gbrp.FormatX(417),0)
    frame:MakePopup()
    frame.bg = Material("gui/gbrp/robbery/background.png")
    frame.bottom = Material("gui/gbrp/robbery/bottom.png")
    if shop:GetBeingRobbed() then
        local remainingTime = Material("gui/gbrp/robbery/remainingTime.png")
        local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
        function frame:Paint(w,h)
            surface.SetDrawColor(2555,255,255,255)
            surface.SetMaterial(self.bg)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(attChar)
            surface.DrawTexturedRect(gbrp.FormatX(124),gbrp.FormatY(318),gbrp.FormatX(200),gbrp.FormatY(600))

            surface.SetMaterial(self.bottom)
            surface.DrawTexturedRect(gbrp.FormatY(102),gbrp.FormatY(897),gbrp.FormatX(823),gbrp.FormatY(82))

            surface.SetTextColor(255,255,255,255)
            surface.SetFont("PricedownHuge")
            surface.SetTextPos(gbrp.FormatX(400),gbrp.FormatY(910))
            surface.DrawText(gbrp.formatMoney(shop:GetBalance() + shop:GetDirtyMoney()))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(gbrp.FormatX(139),gbrp.FormatY(579),gbrp.FormatX(742),gbrp.FormatY(28))
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(gbrp.FormatX(139),gbrp.FormatY(579),gbrp.FormatX(742) * shop:GetRobberyTime() / shop.robbery.time, gbrp.FormatY(28))

            surface.SetFont("PricedownLarge")
            surface.SetTextColor(255,255,255,255)
            surface.SetTextPos(gbrp.FormatX(479),gbrp.FormatY(539))
            surface.DrawText(tostring(math.Round(100 * shop:GetRobberyTime() / shop.robbery.time) .. "%"))

            surface.SetMaterial(remainingTime)
            surface.DrawTexturedRect(gbrp.FormatX(300),gbrp.FormatY(624),gbrp.FormatX(250),gbrp.FormatY(32))

            surface.SetTextPos(gbrp.FormatX(570),gbrp.FormatY(620))
            surface.DrawText(tostring(shop.robbery.time - shop:GetRobberyTime()) .. " secondes")
        end
        local remove = vgui.Create("RemoveButton",frame)
        remove:SetSize(30,33)
        remove:SetPos(gbrp.FormatX(882),gbrp.FormatY(110))
        remove:SetSize(gbrp.FormatX(30),gbrp.FormatY(33))
    else
        function frame:Paint(w,h)
            surface.SetDrawColor(2555,255,255,255)
            surface.SetMaterial(self.bg)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(time)
            surface.DrawTexturedRect(gbrp.FormatX(334),gbrp.FormatY(753),gbrp.FormatX(375),gbrp.FormatY(30))

            surface.SetMaterial(att)
            surface.DrawTexturedRect(gbrp.FormatX(295),gbrp.FormatY(376),gbrp.FormatX(att:Width()),gbrp.FormatY(att:Height()))

            surface.SetMaterial(attChar)
            surface.DrawTexturedRect(gbrp.FormatX(124),gbrp.FormatY(318),gbrp.FormatX(200),gbrp.FormatY(600))

            surface.SetMaterial(def)
            surface.DrawTexturedRect(gbrp.FormatX(648),gbrp.FormatY(376),gbrp.FormatX(def:Width()),gbrp.FormatY(def:Height()))

            surface.SetMaterial(defChar)
            surface.DrawTexturedRect(gbrp.FormatX(712),gbrp.FormatY(318),gbrp.FormatX(200),gbrp.FormatY(600))

            surface.SetMaterial(self.bottom)
            surface.DrawTexturedRect(gbrp.FormatY(102),gbrp.FormatY(897),gbrp.FormatX(823),gbrp.FormatY(82))

            surface.SetTextColor(255,255,255,255)
            surface.SetFont("PricedownHuge")
            surface.SetTextPos(gbrp.FormatX(400),gbrp.FormatY(910))
            surface.DrawText(gbrp.formatMoney(shop:GetBalance() + shop:GetDirtyMoney()))
        end
        local remove = vgui.Create("RemoveButton",frame)
        remove:SetSize(30,33)
        remove:SetPos(gbrp.FormatX(882),gbrp.FormatY(110))
        remove:SetSize(gbrp.FormatX(30),gbrp.FormatY(33))
        local braquer = vgui.Create("DImageButton",frame)
        braquer:SetImage("gui/gbrp/robbery/braquer.png")
        braquer:SetPos(gbrp.FormatX(341),gbrp.FormatY(568))
        braquer:SetSize(gbrp.FormatX(371),gbrp.FormatY(176))
        function braquer:GetMaterial()
            return Material(self:GetImage())
        end
        function braquer:OnCursorEntered()
            self:SetImage("gui/gbrp/robbery/braquerrollover.png")
            self:SetSize(gbrp.FormatX(self:GetMaterial():Width()),gbrp.FormatY(self:GetMaterial():Height()))
        end
        function braquer:OnCursorExited()
            self:SetImage("gui/gbrp/robbery/braquer.png")
            self:SetSize(gbrp.FormatX(self:GetMaterial():Width()),gbrp.FormatY(self:GetMaterial():Height()))
        end
        braquer.DoClick = function()
            frame:Remove()
            if shop:GetBalance() + shop:GetDirtyMoney() > 0 then
                net.Start("GBRP::startRobbery")
                net.WriteEntity(shop)
                net.SendToServer()
            else
                ply:ChatPrint("Il n'y a pas assez d'argent dans les caisses")
            end
        end
    end
end)
net.Receive("GBRP::bankruptMessage",function()
    local shop = net.ReadEntity()
    local amount = net.ReadInt(32)
    local niceName = net.ReadString()
    local ply = LocalPlayer()
    local ct = CurTime()
    frame = vgui.Create("DFrame",GetHUDPanel())
    frame:SetTitle(niceName .. " a été braqué")
    frame:SetSize(gbrp.FormatX(500),gbrp.FormatY(500))
    frame:Center()
    frame:MakePopup()
    function frame:Think()
        if CurTime() > ct + 20 then
            frame:Remove()
            net.Start("GBRP::shopSolvation")
            net.WriteBool(false)
            net.WriteEntity(shop)
            net.SendToServer()
        end
    end
    local label = vgui.Create("DLabel",frame)
    label:SetText("DermaLarge")
    label:SetText(niceName .. " a été braqué.\nPayer la facture?\nNe pas payer entraine une liquidation.")
    label:CenterHorizontal(.5)
    label:CenterVertical(.4)
    local yes = vgui.Create("DButton",frame)
    yes:CenterHorizontal(.45)
    yes:CenterVertical(.6)
    yes:SetText("Payer")
    yes.DoClick = function()
        frame:Remove()
        net.Start("GBRP::ShopSolvation")
        if ply:GetGang():GetBalance() >= amount then
            net.WriteBool(true)
            net.WriteInt(amount,32)
        else
            ply:ChatPrint("Le gang n'a pas les fonds nécessaires, le commerce a été liquidé")
            net.WriteBool(false)
            net.WriteEntity(shop)
        end
        net.SendToServer()
    end
    local no = vgui.Create("DButton",frame)
    no:CenterHorizontal(.55)
    no:CenterVertical(.6)
    no:SetText("Liquider")
    no.DoClick = function()
        frame:Remove()
        net.Start("GBRP::shopSolvation")
        net.WriteBool(false)
        net.WriteEntity(shop)
        net.SendToServer()
    end
    local timeLabel = vgui.Create("DLabel",frame)
    timeLabel:SetFont("DermaLarge")
    timeLabel:CenterHorizontal(.5)
    function timeLabel:Think()
        self:SetText("Temps restant : " .. tostring(math.Round(ct + 20 - CurTime()) .. " secondes"))
        self:CenterHorizontal(.5)
    end
end)
net.Receive("GBRP::hardwarestoreReception",function()
    local shop = net.ReadEntity()
    if IsValid(frame) then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local passive = Material("gui/gbrp/hardwarestore/passive.png")
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame.mat = Material("gui/gbrp/oldpc.png")
    frame.bg = Material("gui/gbrp/hardwarestore/background.jpg")
    frame.shop = shop
    frame:SetPos(287,75)
    frame:SetSize(1376,1005)
    frame:MakePopup()
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)

        surface.SetMaterial(self.bg)
        surface.DrawTexturedRect(109,75,1176,651)

        surface.SetTextColor(255,255,255,255)
        surface.SetFont("Bank")
        surface.SetTextPos(178,677)
        surface.DrawText("SOLDE DU GANG : " .. gbrp.formatMoney(gang:GetBalance()))

        surface.SetMaterial(passive)
        surface.DrawTexturedRect(194,598,302,41)

        surface.SetDrawColor(77,76,70,191)
        surface.DrawRect(125,85,32,593)

        GWEN.CreateTextureNormal(385,114,5,3,defaultSkin)(130,109,23,13,Color(0,0,0,255))
        GWEN.CreateTextureNormal(385,122,5,3,defaultSkin)(130,641,23,13,Color(0,0,0,255))
        surface.SetDrawColor(0,0,0,255)
        surface.DrawRect(125,480,32,64)

        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
    end

    local price = vgui.Create("Panel",frame)
    price:SetPos(666,138)
    price:SetSize(436,68)
    price.Paint = function(self,w,h)
        surface.SetDrawColor(0,0,0,150)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,406,16)
        surface.DrawTexturedRectRotated(430,8,16,16,-90)
        surface.DrawRect(0,16,w,60)
    end
    local priceLabel = vgui.Create("DLabel",price)
    priceLabel:SetFont("BankLarge")
    priceLabel:SetColor(Color(255,255,255,255))
    priceLabel:SetText("PRIX : " .. gbrp.formatMoney(shop:GetPrice()))
    priceLabel:SizeToContents()
    priceLabel:Center()

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetSize(30,33)
    remove:SetPos(1213,222)

    local buy = vgui.Create("Button",frame)
    buy:SetPos(768,379)
    buy:SetSize(369,126)
    buy.alpha = 120
    buy.Paint = function(self,w,h)
        surface.SetDrawColor(255,0,0,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    buy:SetFont("BankLarge")
    buy:SetColor(Color(0,0,0,255))
    buy:SetText("A C H E T E R   L E\nC O M M E R C E")
    buy.OnCursorEntered = function(self)
        self.alpha = 200
    end
    buy.OnCursorExited = function(self)
        self.alpha = 120
    end
    buy.DoClick = function()
        ply:BuyShop(shop)
    end

    local customerarea = vgui.Create("Button",frame)
    customerarea:SetSize(369,126)
    customerarea:SetPos(768,529)
    customerarea.alpha = 120
    customerarea.Paint = function(self,w,h)
        surface.SetDrawColor(255,255,255,self.alpha)
        surface.SetTexture(corner16)
        surface.DrawTexturedRect(0,0,16,16)
        surface.DrawRect(16,0,337,16)
        surface.DrawTexturedRectRotated(361,8,16,16,-90)
        surface.DrawRect(0,16,w,94)
        surface.DrawTexturedRectRotated(8,118,16,16,90)
        surface.DrawRect(16,110,337,16)
        surface.DrawTexturedRectRotated(361,118,16,16,180)
    end
    customerarea:SetFont("BankLarge")
    customerarea:SetColor(Color(0,0,0,255))
    customerarea:SetText("M O N   E S P A CE\n       C L I E N T")
    customerarea.OnCursorEntered = function(self)
        self.alpha = 200
    end
    customerarea.OnCursorExited = function(self)
        self.alpha = 120
    end
    local function LoadPage3()
        local shoppingBasket = ""
        local bill = 0
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255,255)

            surface.SetMaterial(self.bg)
            surface.DrawTexturedRect(109,75,1176,651)

            surface.SetTextColor(255,255,255,255)
            surface.SetFont("Bank")
            surface.SetTextPos(178,677)
            surface.DrawText("SOLDE DU GANG : " .. gbrp.formatMoney(gang:GetBalance()))

            surface.SetDrawColor(77,76,70,191)
            surface.DrawRect(125,85,32,593)

            GWEN.CreateTextureNormal(385,114,5,3,defaultSkin)(130,109,23,13,Color(0,0,0,255))
            GWEN.CreateTextureNormal(385,122,5,3,defaultSkin)(130,641,23,13,Color(0,0,0,255))
            surface.SetDrawColor(0,0,0,255)
            surface.DrawRect(125,480,32,64)

            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(gbrp.hardwarestore.crowbar)
            surface.DrawTexturedRect(859,376,42,47)
            surface.SetMaterial(gbrp.hardwarestore.peinture)
            surface.DrawTexturedRect(789,409,39,61)
            surface.SetMaterial(gbrp.hardwarestore.slam)
            surface.DrawTexturedRect(858,464,44,35)
            surface.SetMaterial(gbrp.hardwarestore.hookMat)
            surface.DrawTexturedRect(792,497,33,49)
            surface.SetMaterial(gbrp.hardwarestore.handscuffs)
            surface.DrawTexturedRect(844,533,63,57)
            surface.SetMaterial(gbrp.hardwarestore.c4)
            surface.DrawTexturedRect(777,585,54,27)
            surface.SetMaterial(gbrp.hardwarestore.walkieTalkie)
            surface.DrawTexturedRect(857,605,36,67)
            surface.SetMaterial(gbrp.hardwarestore.trace)
            surface.DrawTexturedRect(893,371,279,59)
            surface.DrawTexturedRect(893,454,279,59)
            surface.DrawTexturedRect(893,534,279,59)
            surface.DrawTexturedRect(893,620,279,59)
            surface.DrawTexturedRect(813,413,359,59)
            surface.DrawTexturedRect(813,494,359,59)
            surface.DrawTexturedRect(813,573,359,59)
        end
        for k,v in ipairs(gbrp.hardwarestore.items) do
            v.button = vgui.Create("DButton",frame)
            v.button:SetSize(71,28)
            v.button:SetPos(1156,v.y)
            function v.button:Paint(w,h)
                if self:IsHovered() then
                    return GWEN.CreateTextureBorder(480,32,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,0,30,179))
                elseif self.isSelected then
                    return GWEN.CreateTextureBorder(480,32,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,0,30,255))
                end
                GWEN.CreateTextureBorder(480,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,0,30,102))
            end
            function v.button:DoClick()
                shoppingBasket = v.name
                bill = v.price
                for _,v1 in pairs(gbrp.hardwarestore.items) do
                    v1.button.isSelected = false
                end
                self.isSelected = true
            end
            v.button:SetText(gbrp.formatMoney(gbrp.hardwarestore.items[k].price))
            v.button:SetFont("Trebuchet24")
            v.button:SetColor(Color(0,0,0))
        end

        local pay = vgui.Create("GBRPButton",frame)
        pay.mat = Material("gui/gbrp/hardwarestore/pay.png")
        pay.hoveredMat = Material("gui/gbrp/hardwarestore/pay_hover.png")
        pay:SetPos(235,553)
        pay:SetSize(155,69)
        function pay:DoClick()
            if shoppingBasket == "" then GAMEMODE:AddNotify("Veuillez sélectionner un article.",1,2) return end
            if ply:CanAfford(bill) then
                frame:Remove()
                net.Start("GBRP::buyhardware")
                net.WriteString(shoppingBasket)
                net.SendToServer()
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    local function LoadPage2()
        local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255,255)

            surface.SetMaterial(self.bg)
            surface.DrawTexturedRect(109,75,1176,651)

            surface.SetTextColor(255,255,255,255)
            surface.SetFont("Bank")
            surface.SetTextPos(178,677)
            surface.DrawText("SOLDE DU GANG : " .. gbrp.formatMoney(gang:GetBalance()))

            surface.SetDrawColor(77,76,70,191)
            surface.DrawRect(125,85,32,593)

            GWEN.CreateTextureNormal(385,114,5,3,defaultSkin)(130,109,23,13,Color(0,0,0,255))
            GWEN.CreateTextureNormal(385,122,5,3,defaultSkin)(130,641,23,13,Color(0,0,0,255))
            surface.SetDrawColor(0,0,0,255)
            surface.DrawRect(125,480,32,64)

            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            local barHeight = 579 * math.Round(shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()),2)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(179,89,27,579)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(179,668 - barHeight, 27, barHeight)

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0,255)
            surface.SetTextPos(222,371)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (.01 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")
        end

        local balance = vgui.Create("DImage",frame)
        balance:SetImage("gui/gbrp/gunshop/page2/balance.png")
        balance:SetPos(222,592)
        balance:SetSize(321,68)
        local balanceLabel = vgui.Create("DLabel",balance)
        balanceLabel:SetFont("BankSmall")
        balanceLabel:SetColor(Color(255,255,255,255))
        balanceLabel:SetText(gbrp.formatMoney(shop:GetBalance()))
        balanceLabel:SizeToContents()
        balanceLabel:CenterHorizontal(.5)
        balanceLabel:CenterVertical(.7)

        local value = vgui.Create("DImage",frame)
        value:SetImage("gui/gbrp/gunshop/page2/value.png")
        value:SetPos(886,579)
        value:SetSize(321,68)
        local valueLabel = vgui.Create("DLabel",value)
        valueLabel:SetFont("BankSmall")
        valueLabel:SetColor(Color(255,0,0,255))
        valueLabel:SetText(gbrp.formatMoney(shop:GetValue()))
        valueLabel:SizeToContents()
        valueLabel:CenterHorizontal(.5)
        valueLabel:CenterVertical(.7)

        local dropcash = vgui.Create("DropCashButton",frame)
        dropcash.mat = Material("gui/gbrp/jewelrystore/dropcash.png")
        dropcash.hoveredMat = Material("gui/gbrp/jewelrystore/dropcashrollover.png")
        dropcash:SetSize(321,105)
        dropcash:SetPos(510,91)

        local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
        withdraw.mat = Material("gui/gbrp/jewelrystore/withdraw.png")
        withdraw.hoveredMat = Material("gui/gbrp/jewelrystore/withdrawrollover.png")
        withdraw:SetSize(321,105)
        withdraw:SetPos(875,91)

        local sell = vgui.Create("SellShopButton",frame)
        sell.mat = Material("gui/gbrp/bar/sell.png")
        sell.hoveredMat = Material("gui/gbrp/bar/sellrollover.png")
        sell:SetSize(321,105)
        sell:SetPos(886,444)

        local outils = vgui.Create("GBRPButton",frame)
        outils.mat = Material("gui/gbrp/hardwarestore/outils.png")
        outils.hoveredMat = Material("gui/gbrp/hardwarestore/outils_hover.png")
        outils:SetPos(734,369)
        outils:SetSize(197,44)
        outils.DoClick = function()
            outils:Remove()
            sell:Remove()
            withdraw:Remove()
            dropcash:Remove()
            balance:Remove()
            balanceLabel:Remove()
            value:Remove()
            valueLabel:Remove()
            LoadPage3()
        end
    end
    customerarea.DoClick = function()
        if shop:GetGang() ~= gang then GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2) return end
        customerarea:Remove()
        buy:Remove()
        price:Remove()
        LoadPage2()
    end
end)