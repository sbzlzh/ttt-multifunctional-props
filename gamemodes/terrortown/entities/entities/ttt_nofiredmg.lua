if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "nofiredmg_name", "No Fire Damage")
    LANG.AddToLanguage("english", "nofiredmg_desc", "Makes you immune to fire damage.")
	LANG.AddToLanguage("简体中文", "nofiredmg_name", "消防员")
    LANG.AddToLanguage("简体中文", "nofiredmg_desc", "让你免疫火焰伤害.")
	
end

EQUIP_NOFIRE = GenerateNewEquipmentID and GenerateNewEquipmentID() or 69

local nofiredmg = {
	id = EQUIP_NOFIRE,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_nofiredmg",
	name = "nofiredmg_name",
	desc = "nofiredmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], nofiredmg)
table.insert(EquipmentItems[ROLE_TRAITOR], nofiredmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoFireDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_BURN) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NOFIRE) then
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
    hook.Add("TTTBoughtItem", "TTTNoFireDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOFIRE)) then
            yCoordinate = getYCoordinate(EQUIP_NOFIRE)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_nofiredmg.png")

    hook.Add("HUDPaint", "TTTNoFireDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOFIRE)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end