function ListBuildings( keys )
	keys.caster:RemoveAbility("antimage_blink")
	keys.caster:RemoveAbility("repair")
	keys.caster:RemoveAbility("shield")
	keys.caster:RemoveAbility("root")
	keys.caster:RemoveAbility("death_prophet_silence")
	keys.caster:RemoveAbility("buildings")
	print("spells removed")
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
	print("frist page of buildings ready")
	--keys.caster:SetMaxHealth(1)
end

function TurnRight( keys )
	keys.caster:RemoveAbility("build_rock_lvl_1")
	keys.caster:RemoveAbility("build_house")
	keys.caster:RemoveAbility("build_tower")
	keys.caster:RemoveAbility("build_castle")
	keys.caster:RemoveAbility("navigation_right")
	print("frist page of buildings removed")
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
	print("second page of buildings ready")
	--keys.caster:SetMaxHealth(1)
end

function TurnLeft( keys )
	keys.caster:RemoveAbility("build_guild")
	keys.caster:RemoveAbility("build_tree")
	keys.caster:RemoveAbility("build_lab")
	keys.caster:RemoveAbility("build_true_tower")
	keys.caster:RemoveAbility("navigation_left")
	print("second page of buildings removed")
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
	print("frist page of buildings ready")
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
		print("frist page of buildings removed")
	else
		keys.caster:RemoveAbility("build_guild")
		keys.caster:RemoveAbility("build_tree")
		keys.caster:RemoveAbility("build_lab")
		keys.caster:RemoveAbility("build_true_tower")
		keys.caster:RemoveAbility("navigation_left")
		keys.caster:RemoveAbility("navigation_back")
		print("second page of buildings removed")
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
	print("spells ready")
	--keys.caster:SetMaxHealth(1)
end

function Repair( keys )
	caster = keys.caster
	building = keys.target
	print("--- Repair; Regen: " .. building:GetHealthRegen() .. " ---")
	building:SetBaseHealthRegen( building:GetHealthRegen() + .85 )
	print( "--- Rapairing " .. building:GetHealthRegen() .. " HP/sec")
end

function CancelRepair( keys )
	caster = keys.caster
	building = keys.target
	print( "--- CancelRepair; Regen: " .. building:GetHealthRegen() .. " ---" )

	if building:GetHealthRegen() - .85 < 0 then
		building:SetBaseHealthRegen( 0 )
	else
		building:SetBaseHealthRegen( building:GetHealthRegen() - .85 )
	end

	-- thinker for checking every sec if unit is not full hp yet if yes call CancelRepair
	-- temporary fix
	if building:GetHealth() ~= building:GetMaxHealth() then
		keys.caster:CastAbilityOnTarget( building, caster:FindAbilityByName( "repair" ), caster:GetOwner():GetPlayerID() )
	end
	print( "--- BTN regen: " .. building:GetHealthRegen() )
end