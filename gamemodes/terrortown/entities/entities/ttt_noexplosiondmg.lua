if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "noexplosiondmg_name", "No Explosion Damage")
    LANG.AddToLanguage("english", "noexplosiondmg_desc", "Makes you immune to explosion damage.")
	LANG.AddToLanguage("简体中文", "noexplosiondmg_name", "防爆部队")
    LANG.AddToLanguage("简体中文", "noexplosiondmg_desc", "让你免疫爆炸伤害.")
	
end

EQUIP_NOEXPLOSION = GenerateNewEquipmentID and GenerateNewEquipmentID() or 68

local noexplosiondmg = {
	id = EQUIP_NOEXPLOSION,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_noexplosiondmg",
	name = "noexplosiondmg_name",
	desc = "noexplosiondmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], noexplosiondmg)
table.insert(EquipmentItems[ROLE_TRAITOR], noexplosiondmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoExplosionDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsExplosionDamage() then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NOEXPLOSION) then
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
    hook.Add("TTTBoughtItem", "TTTNoExplosionDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOEXPLOSION)) then
            yCoordinate = getYCoordinate(EQUIP_NOEXPLOSION)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_noexplosiondmg.png")

    hook.Add("HUDPaint", "TTTNoExplosionDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOEXPLOSION)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end