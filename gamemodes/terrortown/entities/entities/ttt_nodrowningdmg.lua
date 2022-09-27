if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "nodrowningdmg_name", "No Drowning Damage")
    LANG.AddToLanguage("english", "nodrowningdmg_desc", "Makes you immune to drowning damage.")
	LANG.AddToLanguage("简体中文", "nodrowningdmg_name", "潜水员")
    LANG.AddToLanguage("简体中文", "nodrowningdmg_desc", "让你免疫溺水伤害.")
end

EQUIP_NODROWNING = GenerateNewEquipmentID and GenerateNewEquipmentID() or 66

local nodrowningdmg = {
	id = EQUIP_NODROWNING,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_nodrowningdmg",
	name = "nodrowningdmg_name",
	desc = "nodrowningdmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], nodrowningdmg)
table.insert(EquipmentItems[ROLE_TRAITOR], nodrowningdmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoDrownDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_DROWN) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NODROWNING) then
			dmginfo:ScaleDamage(0)
		end
	end)
end

if CLIENT then
    -- feel for to use this function for your own perk, but please credit me
    -- your perk needs a "hud = true" in the table, to work properly
    local defaultY = ScrH() / 2 + 20

    local function getYCoordinate(currentPerkID)
        local amount, i, perk = 0, 1

        while (i < currentPerkID) do
            perk = GetEquipmentItem(LocalPlayer():GetRole(), i)

            if (istable(perk) and perk.hud and LocalPlayer():HasEquipmentItem(perk.id)) then
                amount = amount + 1
            end

            i = i * 2
        end

        return defaultY - 80 * amount
    end

    local yCoordinate = defaultY

    -- best performance, but the has about 0.5 seconds delay to the HasEquipmentItem() function
    hook.Add("TTTBoughtItem", "TTTNoDrownDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NODROWNING)) then
            yCoordinate = getYCoordinate(EQUIP_NODROWNING)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_nodrowningdmg.png")

    hook.Add("HUDPaint", "TTTNoDrownDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NODROWNING)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end