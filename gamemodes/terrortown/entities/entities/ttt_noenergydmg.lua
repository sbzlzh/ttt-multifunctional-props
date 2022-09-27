if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "noenergydmg_name", "No Energy Damage")
    LANG.AddToLanguage("english", "noenergydmg_desc", "Makes you immune to energy damage such as lasers, plasma and lightning.")
	LANG.AddToLanguage("简体中文", "noenergydmg_name", "电男")
    LANG.AddToLanguage("简体中文", "noenergydmg_desc", "让你免疫激光,电浆和电磁伤害.")
	
end

EQUIP_NOENERGY = GenerateNewEquipmentID and GenerateNewEquipmentID() or 67

local noenergydmg = {
	id = EQUIP_NOENERGY,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_noenergydmg",
	name = "noenergydmg_name",
	desc = "noenergydmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], noenergydmg)
table.insert(EquipmentItems[ROLE_TRAITOR], noenergydmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoEnergyDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer()
			or not (dmginfo:IsDamageType(DMG_SHOCK) or dmginfo:IsDamageType(DMG_SONIC) or dmginfo:IsDamageType(DMG_ENERGYBEAM) or dmginfo:IsDamageType(DMG_PHYSGUN) or dmginfo:IsDamageType(DMG_PLASMA))
		then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NOENERGY) then
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
    hook.Add("TTTBoughtItem", "TTTNoEnergyDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOENERGY)) then
            yCoordinate = getYCoordinate(EQUIP_NOENERGY)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_noenergydmg.png")

    hook.Add("HUDPaint", "TTTNoEnergyDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOENERGY)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end