if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "nohazarddmg_name", "No Hazard Damage")
    LANG.AddToLanguage("english", "nohazarddmg_desc", "Makes you immune to hazard damage such as poison, radiation and acid.")
	LANG.AddToLanguage("简体中文", "nohazarddmg_name", "防化部队")
    LANG.AddToLanguage("简体中文", "nohazarddmg_desc", "让你免疫硫酸,辐射和毒气伤害.")
	
end

EQUIP_NOHAZARD = GenerateNewEquipmentID and GenerateNewEquipmentID() or 70

local nohazarddmg = {
	id = EQUIP_NOHAZARD,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_nohazarddmg",
	name = "nohazarddmg_name",
	desc = "nohazarddmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], nohazarddmg)
table.insert(EquipmentItems[ROLE_TRAITOR], nohazarddmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoHazardDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer()
			or not (dmginfo:IsDamageType(DMG_POISON) or dmginfo:IsDamageType(DMG_NERVEGAS) or dmginfo:IsDamageType(DMG_RADIATION) or dmginfo:IsDamageType(DMG_ACID) or dmginfo:IsDamageType(DMG_DISSOLVE))
		then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NOHAZARD) then
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
    hook.Add("TTTBoughtItem", "TTTNoHazardDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOHAZARD)) then
            yCoordinate = getYCoordinate(EQUIP_NOHAZARD)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_nohazarddmg.png")

    hook.Add("HUDPaint", "TTTNoHazardDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOHAZARD)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end