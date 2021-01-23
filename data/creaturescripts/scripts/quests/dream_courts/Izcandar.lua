local sides = {
	{fromPosition = Position(32209, 32040, 14), toPosition = Position(32217, 32056, 14)},
	{fromPosition = Position(32197, 32038, 14), toPosition = Position(32206, 32055, 14)},
	{fromPosition = Position(32207, 32040, 14), toPosition = Position(32208, 32055, 14)},
}

function onThink(creature)
	if not creature:isMonster() then
		return true
	end	
	
	local cPos = creature:getPosition()
	local version = Game.getStorageValue(GlobalStorage.DreamCourts.DreamScar.izcandarOutfit)

	-- Alocando variáveis
	local health = creature:getHealth()
	local position = creature:getPosition()
	local cName = creature:getName():lower()

	if cPos:isInRange(sides[1].fromPosition, sides[1].toPosition) and not (cName == "izcandar champion of winter") then -- winter side
		Game.setStorageValue(GlobalStorage.DreamCourts.DreamScar.izcandarOutfit, 1)
	elseif cPos:isInRange(sides[2].fromPosition, sides[2].toPosition) and not (cName == "izcandar champion of summer") then -- summer side
		Game.setStorageValue(GlobalStorage.DreamCourts.DreamScar.izcandarOutfit, 2)
	elseif cPos:isInRange(sides[3].fromPosition, sides[3].toPosition) and not (cName == "izcandar the banished") then -- middle
		Game.setStorageValue(GlobalStorage.DreamCourts.DreamScar.izcandarOutfit, 0)
	end

	if version == 1 and not (cName == "izcandar champion of winter") then
		creature:remove()
		local monster = Game.createMonster("Izcandar Champion of Winter", position)
		if monster then
			monster:registerEvent('izcandarThink')
			monster:addHealth(-(monster:getHealth() - health))
		end
	elseif version == 2 and not (cName == "izcandar champion of summer") then
		creature:remove()
		local monster = Game.createMonster("Izcandar Champion of Summer", position)
		if monster then
			monster:registerEvent('izcandarThink')
			monster:addHealth(-(monster:getHealth() - health))
		end
	elseif version == 0 and not (cName == "izcandar the banished") then
		creature:remove()
		local monster = Game.createMonster("Izcandar the Banished", position)
		if monster then
			monster:registerEvent('izcandarThink')
			monster:addHealth(-(monster:getHealth() - health))
		end
	end
	return true
end