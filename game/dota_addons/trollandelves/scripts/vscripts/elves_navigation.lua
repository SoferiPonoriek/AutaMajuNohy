function ListBuildings( keys )
	keys.caster:RemoveAbility("antimage_blink")
	keys.caster:RemoveAbility("repair")
	keys.caster:RemoveAbility("shield")
	keys.caster:RemoveAbility("root")
	keys.caster:RemoveAbility("death_prophet_silence")
	keys.caster:RemoveAbility("buildings")
	print("[t&e] spells removed")
	keys.caster:AddAbility("build_rock_lvl_1")
	keys.caster:AddAbility("build_house")
	keys.caster:AddAbility("build_tower")
	keys.caster:AddAbility("build_castle")
	keys.caster:AddAbility("navigation_right")
	keys.caster:AddAbility("navigation_back")
	keys.caster:FindAbilityByName("build_rock_lvl_1"):SetLevel(1)
	keys.caster:FindAbilityByName("build_house"):SetLevel(1)
	keys.caster:FindAbilityByName("build_tower"):SetLevel(1)
	keys.caster:FindAbilityByName("build_castle"):SetLevel(1)
	keys.caster:FindAbilityByName("navigation_right"):SetLevel(1)
	keys.caster:FindAbilityByName("navigation_back"):SetLevel(1)
	print("[t&e] frist page of buildings ready")
	--keys.caster:SetMaxHealth(1)
end

function TurnRight( keys )
	keys.caster:RemoveAbility("build_rock_lvl_1")
	keys.caster:RemoveAbility("build_house")
	keys.caster:RemoveAbility("build_tower")
	keys.caster:RemoveAbility("build_castle")
	keys.caster:RemoveAbility("navigation_right")
	print("[t&e] frist page of buildings removed")
	keys.caster:AddAbility("build_guild")
	keys.caster:AddAbility("build_tree")
	keys.caster:AddAbility("build_lab")
	keys.caster:AddAbility("build_true_tower")
	keys.caster:AddAbility("navigation_left")
	keys.caster:FindAbilityByName("build_guild"):SetLevel(1)
	keys.caster:FindAbilityByName("build_tree"):SetLevel(1)
	keys.caster:FindAbilityByName("build_lab"):SetLevel(1)
	keys.caster:FindAbilityByName("build_true_tower"):SetLevel(1)
	keys.caster:FindAbilityByName("navigation_left"):SetLevel(1)
	print("[t&e] second page of buildings ready")
	--keys.caster:SetMaxHealth(1)
end

function TurnLeft( keys )
	keys.caster:RemoveAbility("build_guild")
	keys.caster:RemoveAbility("build_tree")
	keys.caster:RemoveAbility("build_lab")
	keys.caster:RemoveAbility("build_true_tower")
	keys.caster:RemoveAbility("navigation_left")
	print("[t&e] second page of buildings removed")
	keys.caster:AddAbility("build_rock_lvl_1")
	keys.caster:AddAbility("build_house")
	keys.caster:AddAbility("build_tower")
	keys.caster:AddAbility("build_castle")
	keys.caster:AddAbility("navigation_right")
	keys.caster:FindAbilityByName("build_rock_lvl_1"):SetLevel(1)
	keys.caster:FindAbilityByName("build_house"):SetLevel(1)
	keys.caster:FindAbilityByName("build_tower"):SetLevel(1)
	keys.caster:FindAbilityByName("build_castle"):SetLevel(1)
	keys.caster:FindAbilityByName("navigation_right"):SetLevel(1)
	print("[t&e] frist page of buildings ready")
	--keys.caster:SetMaxHealth(1)
end

function BackToSpells( keys )
	if (keys.caster:FindAbilityByName("build_rock_lvl_1"):GetLevel() == 1) then
		keys.caster:RemoveAbility("build_rock_lvl_1")
		keys.caster:RemoveAbility("build_house")
		keys.caster:RemoveAbility("build_tower")
		keys.caster:RemoveAbility("build_castle")
		keys.caster:RemoveAbility("navigation_right")
		keys.caster:RemoveAbility("navigation_back")
		print("[t&e] frist page of buildings removed")
	else
		keys.caster:RemoveAbility("build_guild")
		keys.caster:RemoveAbility("build_tree")
		keys.caster:RemoveAbility("build_lab")
		keys.caster:RemoveAbility("build_true_tower")
		keys.caster:RemoveAbility("navigation_left")
		keys.caster:RemoveAbility("navigation_back")
		print("[t&e] second page of buildings removed")
	end

	keys.caster:AddAbility("antimage_blink")
	keys.caster:AddAbility("repair")
	keys.caster:AddAbility("shield")
	keys.caster:AddAbility("root")
	keys.caster:AddAbility("death_prophet_silence")
	keys.caster:AddAbility("buildings")
	keys.caster:FindAbilityByName("antimage_blink"):SetLevel(1)
	keys.caster:FindAbilityByName("repair"):SetLevel(1)
	keys.caster:FindAbilityByName("shield"):SetLevel(1)
	keys.caster:FindAbilityByName("root"):SetLevel(1)
	keys.caster:FindAbilityByName("death_prophet_silence"):SetLevel(1)
	keys.caster:FindAbilityByName("buildings"):SetLevel(1)
	print("[t&e] spells ready")
	--keys.caster:SetMaxHealth(1)
end

function Repair( keys )
	caster = keys.caster
	building = keys.target
	-- Set bigger healt regen
	building:SetBaseHealthRegen( building:GetHealthRegen() + .85 )
	-- Create timer that will check hp of building, for each player own
	Secret:CreateTimer( "repairPlayer" .. caster:GetPlayerID(), {
		callback = function()
		-- Check if building isn't already on full hp
			if building:GetHealth() == building:GetMaxHealth() then
				-- If yes cancle cast
				CancelRepair(keys)
			end
    	return 1.0
    	end
	})
end

function CancelRepair( keys )
	caster = keys.caster
	building = keys.target
	-- Remove timer created in Repair( keys )
	Secret:RemoveTimer( "repairPlayer" .. caster:GetPlayerID() )
	-- Make sure that regen of building woudln't be lower then nil
	if building:GetHealthRegen() - .85 < 0 then
		building:SetBaseHealthRegen( 0 )
	else
		building:SetBaseHealthRegen( building:GetHealthRegen() - .85 )
	end
	-- If building is missing any HP continue in repairing
	if building:GetHealth() ~= building:GetMaxHealth() then
		keys.caster:CastAbilityOnTarget( building, caster:FindAbilityByName( "repair" ), caster:GetOwner():GetPlayerID() )
	else
		-- else interrupt
		keys.caster:InterruptChannel()
	end
end