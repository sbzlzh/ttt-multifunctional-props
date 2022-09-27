if SERVER then
	AddCSLuaFile()
else
    LANG.AddToLanguage("english", "nofalldmg_name", "No Fall Damage")
    LANG.AddToLanguage("english", "nofalldmg_desc", "Makes you immune to fall damage.")
	LANG.AddToLanguage("简体中文", "nofalldmg_name", "金刚不败腿")
    LANG.AddToLanguage("简体中文", "nofalldmg_desc", "让你免疫摔落伤害.")
	
end

EQUIP_NOFALL = GenerateNewEquipmentID and GenerateNewEquipmentID() or 68

local nofalldmg = {
	id = EQUIP_NOFALL,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_nofalldmg",
	name = "nofalldmg_name",
	desc = "nofalldmg_desc",
	hud = true
}

table.insert(EquipmentItems[ROLE_DETECTIVE], nofalldmg)
table.insert(EquipmentItems[ROLE_TRAITOR], nofalldmg)

if SERVER then
	hook.Add("EntityTakeDamage", "TTTNoFallDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsFallDamage() then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem(EQUIP_NOFALL) then
			dmginfo:ScaleDamage(0)
		end
	end)

	hook.Add("OnPlayerHitGround", "TTTNoFallDmg", function(ply)
		if ply:Alive() and ply:IsTerror() and ply:HasEquipmentItem(EQUIP_NOFALL) then
			return false
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
    hook.Add("TTTBoughtItem", "TTTNoFallDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOFALL)) then
            yCoordinate = getYCoordinate(EQUIP_NOFALL)
        end
    end)

    -- draw the HUD icon
    local material = Material("vgui/ttt/perks/hud_nofalldmg.png")

    hook.Add("HUDPaint", "TTTNoFallDmg", function()
        if (LocalPlayer():HasEquipmentItem(EQUIP_NOFALL)) then
            surface.SetMaterial(material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(20, yCoordinate, 64, 64)
        end
    end)
end