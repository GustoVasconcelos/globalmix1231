local config = ScarlettBossFight.config

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getLevel() < config.requiredLevel then
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("You must be atlest level %d to use this item.", config.requiredLevel))
		return true
	end

	local validPosition = false
	for _, position in ipairs(config.playerPositions) do
		if position == player:getPosition() then
			validPosition = true
			break
		end
	end

	local leverPosition = item:getPosition()
	if not validPosition then
		return false
	end

	if ScarlettBossFight.room.time > os.time() then
		player:say(string.format('You must wait %s before entrace on this area.', showTimeLeft(ScarlettBossFight.room.time - os.time(), true)), TALKTYPE_MONSTER_SAY, false, nil, leverPosition)
		return true
	end

	if player:getStorageValue(config.storage) >= os.time() then
		player:say(string.format('You must wait %s before fight again with the boss.', showTimeLeft(player:getStorageValue(config.storage) - os.time(), true)), TALKTYPE_MONSTER_SAY, false, nil, leverPosition)
		return true
	end

	local leverPosition = item:getPosition()

	local players = { }
	for _, position in pairs(config.playerPositions) do
		local tile = Tile(position)
		if tile then
			local topCreature = tile:getTopCreature()
			if topCreature and topCreature:isPlayer() then
				if topCreature:getStorageValue(config.storage) >= os.time() then
					topCreature:say(string.format('%s must wait %s before fight again with the boss.', topCreature:getName(), showTimeLeft(topCreature:getStorageValue(config.storage) - os.time(), true)), TALKTYPE_MONSTER_SAY, false, nil, leverPosition)
					return true
				end

				if topCreature:getLevel() < config.requiredLevel then
					player:sendTextMessage(MESSAGE_STATUS_SMALL, "All the players need to be level ".. config.requiredLevel .." or higher.")
					return true
				end
				
				players[#players + 1] = topCreature
			end
		end
	end

	local specs = Game.getSpectators(config.centerPosition, false, false, 10, 10, 10, 10)
	for i = 1, #specs do
		local spec = specs[i]
		if spec:isPlayer() then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "There is someone already inside this room.")
			return true
		end
	end

	local specs = Game.getSpectators(config.centerPosition, false, false, 7, 7, 7, 7)
	for i = 1, #specs do
		local spec = specs[i]
		if spec:isMonster() then
			spec:remove()
		end
	end

	local monster = Game.createMonster(config.monstersSpawn.name, config.monstersSpawn.position)
	if not monster then
		return
	end

	local newPosition = Position(config.newPosition.x + 1, config.newPosition.y, config.newPosition.z)
	for i = 1, #players do
		local tmpPlayer = players[i]
		config.playerPositions[i]:sendMagicEffect(CONST_ME_POFF)

		newPosition = Position(newPosition.x + 1, newPosition.y, newPosition.z)
		tmpPlayer:teleportTo(newPosition)
		newPosition:sendMagicEffect(CONST_ME_TELEPORT)

		tmpPlayer:setDirection(DIRECTION_NORTH)
		tmpPlayer:setStorageValue(config.storage, os.time() + (20 * 3600))
	end

	ScarlettBossFight.room.time = os.time() + (20 * 60)
	ScarlettBossFight.room.id = ScarlettBossFight.room.id + 1
	ScarlettBossFight.room.activated = true
	ScarlettBossFight.room.canReceiveDamage = false
	ScarlettBossFight.room.monsterId = monster:getId()

	ScarlettBossFight:createArmorItem()
	ScarlettBossFight:randomizeMirrors()

	addEvent(
		function(ScarlettBossFight)
			ScarlettBossFight:createArmorItem() 
		end, 
		math.random(30, 40) * 1000, ScarlettBossFight
	)

	ScarlettBossFight.room.mirrorsEvent = addEvent(
		function(ScarlettBossFight)
			ScarlettBossFight:changeMirrors() 
		end, 20 * 1000, ScarlettBossFight
	) -- Muda os espelhos da sala a cada 20 segundos
	
	addEvent(
		function(roomId)
			ScarlettBossFight:clearRoom(roomId)
		end, 20 * 60 * 1000, ScarlettBossFight.room.id
	)	
	return true
end