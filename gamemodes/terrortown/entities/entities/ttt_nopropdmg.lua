if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "nopropdmg_name", "No Prop Damage")
    LANG.AddToLanguage("english", "nopropdmg_desc", "Makes you immune to prop damage.")
	LANG.AddToLanguage("简体中文", "nopropdmg_name", "头铁")
    LANG.AddToLanguage("简体中文", "nopropdmg_desc", "让你免疫物品伤害.")
	
end

EQUIP_NOPROP = GenerateNewEquipmentID and GenerateNewEquipmentID() or 71

local nopropdmg = {
	id = EQUIP_NOPROP,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_nopropdmg",
	name = "nopropdmg_name",
	desc = "nopropdmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], nopropdmg)
table.insert(EquipmentItems[ROLE_TRAITOR], nopropdmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoPropDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_CRUSH) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NOPROP) then
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
    hook.Add("TTTBoughtItem", "TTTNoPropDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOPROP)) then
            yCoordinate = getYCoordinate(EQUIP_NOPROP)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_nopropdmg.png")

    hook.Add("HUDPaint", "TTTNoPropDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOPROP)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end