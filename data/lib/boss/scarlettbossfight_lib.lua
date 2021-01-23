if not ScarlettBossFight then
	ScarlettBossFight = { 
		room = {
			id = 0,
			time = 0,
			monsterId = 0,
			activated = false,
			canReceiveDamage = false,
			mirrorsEvent = 0,
		}
	}
end

ScarlettBossFight.config = {
	requiredLevel = 250,
	centerPosition = Position(33396, 32649, 6),
	exitPosition = Position(33395, 32664, 6),
	storage = Storage.KilmareshQuest.scarletBoss,
	newPosition = Position(33395, 32657, 6),
	monstersSpawn = {name = 'Scarlett Etzel', position = Position(33396, 32641, 6)},
	areas = {
		-- Alto
		[1] = {
			fromPosition = Position(33390, 32642, 6),
			toPosition = Position(33394, 32646, 6),
		},
		[2] = {
			fromPosition = Position(33394, 32642, 6),
			toPosition = Position(33398, 32646, 6),
		},
		[3] = {
			fromPosition = Position(33398, 32642, 6),
			toPosition = Position(33402, 32646, 6),
		},

		-- Meio
		[4] = {
			fromPosition = Position(33390, 32646, 6),
			toPosition = Position(33394, 32650, 6),
		},
		[5] = {
			fromPosition = Position(33394, 32646, 6),
			toPosition = Position(33398, 32650, 6),
		},
		[6] = {
			fromPosition = Position(33398, 32646, 6),
			toPosition = Position(33402, 32650, 6),
		},

		-- Baixo
		[7] = {
			fromPosition = Position(33390, 32650, 6),
			toPosition = Position(33394, 32654, 6),
		},
		[8] = {
			fromPosition = Position(33394, 32650, 6),
			toPosition = Position(33398, 32654, 6),
		},
		[9] = {
			fromPosition = Position(33398, 32650, 6),
			toPosition = Position(33402, 32654, 6),
		},
	},
	mirrors = {
		[36309] = 36310,
		[36310] = 36311,
		[36311] = 36312,
		[36312] = 36309,
	},
	playerPositions = {
		Position(33395, 32661, 6),
		Position(33395, 32662, 6),
		Position(33394, 32662, 6),
		Position(33395, 32663, 6),
		Position(33396, 32662, 6),
	},
}

function ScarlettBossFight.clearRoom(self, id)
	if id ~= ScarlettBossFight.room.id then
		return false
	end

	local spectators, spectator = Game.getSpectators(self.config.centerPosition, false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() then
			local exitPosition = self.config.exitPosition
			spectator:teleportTo(exitPosition)
			spectator:say("You were kicked for exceeding the time limit within the boss room.", TALKTYPE_MONSTER_SAY)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end

	self.room.monsterId = 0
	self.room.canReceiveDamage = false
	self.room.activated = false
	
	if self.room.mirrorsEvent ~= 0 then
		stopEvent(self.room.mirrorsEvent)
		self.room.mirrorsEvent = 0
	end
end

function ScarlettBossFight.onCheckPillars(self)
    for index, area in ipairs(self.config.areas) do
        for y = area.fromPosition.y, area.toPosition.y do
            for x = area.fromPosition.x, area.toPosition.x do
                local tile = Tile(Position(x, y, area.toPosition.z))
                if tile then
                    local creature = tile:getTopCreature()
                    if creature then
                        if creature:getName() == "Scarlett Etzel" then
                            local pilarIsCompleted = self:pillarsIsCompleted(index)
                            return pilarIsCompleted
                        end
                    end
                end
            end
        end
    end

    return false
end

function ScarlettBossFight.getPillarsPosition(self, id)
	if not id then
		return
	end

	local area = self.config.areas[id]
	if not area then
		return
	end

	local pillarsPosition = {
		[1] = {name = "pilarNorthLeft", position = area.fromPosition, mustBe = 36309},
		[2] = {name = "pilarNorthRight", position = Position(area.fromPosition.x + 4, area.fromPosition.y, area.fromPosition.z), mustBe = 36310},
		[3] = {name = "pilarSouthLeft", position = area.toPosition, mustBe = 36311},
		[4] = {name = "pilarSouthRight", position = Position(area.fromPosition.x, area.fromPosition.y + 4, area.fromPosition.z), mustBe = 36312},
	}

	return pillarsPosition
end

function ScarlettBossFight.pillarsIsCompleted(self, index)
	local pillarsPosition = self:getPillarsPosition(index)
	local count = 0
	for _, pillar in ipairs(pillarsPosition) do
		local tile = Tile(pillar.position)
		if tile then
			local item = tile:getItemById(pillar.mustBe)
			if item then
				count = count + 1
			end
		end 
	end

	if count >= 4 then
		return true
	end

	return false
end

function ScarlettBossFight.changeMirrors(self)
	if not ScarlettBossFight.room.activated then
		return
	end

	local fromPosition = Position(33390, 32642, 6)
	local toPosition = Position(33402, 32654, 6)

	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			local tile = Tile(x, y, 6)
			if tile then
				for mirrorId, newMirrorId in pairs(self.config.mirrors) do
					local mirror = tile:getItemById(mirrorId)
					if mirror then
						mirror:transform(newMirrorId)
						break
					end
				end
			end
		end
	end

	stopEvent(self.room.mirrorsEvent)
	self.room.mirrorsEvent = addEvent(function(self) self:changeMirrors() end, 20 * 1000, self)
end

function ScarlettBossFight.randomizeMirrors(self)
	local fromPosition = Position(33390, 32642, 6)
	local toPosition = Position(33402, 32654, 6)

	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			local tile = Tile(x, y, 6)
			if tile then
				for mirrorId, newMirrorId in pairs(self.config.mirrors) do
					local mirror = tile:getItemById(mirrorId)
					if mirror then
						mirror:transform(math.random(36309, 36312))
						break
					end
				end
			end
		end
	end
end	

function ScarlettBossFight.isBlinded(self)
	return self.room.canReceiveDamage
end

function ScarlettBossFight.changeBlindStatus(self)
	if self.room.canReceiveDamage then
		self.room.canReceiveDamage = false
	else
		self.room.canReceiveDamage = true
	end
end

function ScarlettBossFight.createArmorItem(self)
	-- Remove se tiver plates na sala
	local fromPosition = Position(33385, 32638, 6)
	local toPosition = Position(33406, 32660, 6)

	local armorPosition = Position(33398, 32640, 6)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			local tile = Tile(x, y, 6)
			if tile and tile:getPosition() ~= armorPosition then
				local item = tile:getItemById(36317)
				if item then
					item:remove()
				end
			end
		end
	end

	-- Cria a plate no lugar
	local armorPosition = Position(33398, 32640, 6)
	local armorTile = Tile(armorPosition)
	if armorTile then
		local armor = armorTile:getItemById(36317)
		if not armor then
			Game.createItem(36317, 1, armorPosition)
		end
	end

	addEvent(function(self) self:createArmorItem() end, math.random(30, 40) * 1000, self)
end