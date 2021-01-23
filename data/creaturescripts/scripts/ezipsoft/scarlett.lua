local mayDie = "scarlett etzel stuck"

local rooms = {
	[1] = {fromPos = Position(33390, 32642, 6), toPos = Position(33394, 32646, 6)},
	[2] = {fromPos = Position(33390, 32646, 6), toPos = Position(33394, 32650, 6)},
	[3] = {fromPos = Position(33390, 32650, 6), toPos = Position(33394, 32654, 6)},
	[4] = {fromPos = Position(33394, 32642, 6), toPos = Position(33398, 32646, 6)},
	[5] = {fromPos = Position(33394, 32646, 6), toPos = Position(33398, 32650, 6)},
	[6] = {fromPos = Position(33394, 32650, 6), toPos = Position(33398, 32654, 6)},
	[5] = {fromPos = Position(33398, 32642, 6), toPos = Position(33402, 32646, 6)},
	[6] = {fromPos = Position(33398, 32646, 6), toPos = Position(33402, 32650, 6)},
	[7] = {fromPos = Position(33398, 32650, 6), toPos = Position(33402, 32654, 6)}
}

local function isMirrorsCorrect(fromPosition, toPosition)
	local transformTo = {
		[36309] = {m = false},
		[36310] = {m = false},
		[36312] = {m = false},
		[36311] = {m = false}
	}
	local it1 = Tile(fromPosition):getItemById(36309)
	local it2 = Tile(Position(fromPosition.x + 4, fromPosition.y, fromPosition.z)):getItemById(36310)
	local it3 = Tile(Position(toPosition.x - 4, toPosition.y, toPosition.z)):getItemById(36312)
	local it4 = Tile(toPosition):getItemById(36311)
	if it1 and it2 and it3 and it4 then
		return true
	end
	return false
end


function onThink(creature)
	if not creature:isMonster() then
		return true
	end
	if SCARLETT_MAY_TRANSFORM ~= 1 then
		return true
	end
	local mirrorsCount = 0
	for _, p in pairs(rooms) do
		if creature:getPosition():isInRange(p.fromPos, p.toPos) then			
			if isMirrorsCorrect(p.fromPos, p.toPos) then
				addEvent(function(cid)
					local c = Creature(cid)
					if c then
						c:say('Galthen... is that you?', TALKTYPE_MONSTER_SAY)
						cHealth = c:getHealth()
						cPosition = c:getPosition()
						c:remove()
						local stuckScarlett = Game.createMonster("Scarlett Etzel Stuck", cPosition)
						if stuckScarlett then
							stuckScarlett:registerEvent('scarlettHealth')
							stuckScarlett:addHealth(-(stuckScarlett:getMaxHealth()-cHealth))
							SCARLETT_MAY_DIE = 1
							SCARLETT_MAY_TRANSFORM = 0
						end
					end
				end, 2*1000, creature:getId())
				return true
			end
		end
	end
	return true
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if SCARLETT_MAY_DIE ~= 1 then return true end
	if not creature:isMonster() or not creature:getName():lower() == mayDie then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local spec = Game.getSpectators(creature:getPosition(), false, false, 4, 4, 4, 4)
	for _, c in pairs(spec) do
		if c and (c:isPlayer() or c:getMaster()) then
			doTargetCombatHealth(creature:getId(), c, COMBAT_EARTHDAMAGE, -7500, -7500, CONST_ME_GROUNDSHAKER)
		end
	end
	addEvent(function(creatureid, attackerid)
		local m = Creature(creatureid)
		if not m then return true end
		if m then
			local dmg = m:getMaxHealth()/4	
			doTargetCombatHealth(attackerid, m, primaryType, -dmg, -dmg, secondaryType, ORIGIN_NONE)
			m:say('AHHHHHHHHHHH!', TALKTYPE_MONSTER_SAY)
			cHealth = m:getHealth()
			cPosition = m:getPosition()
			m:remove()
			local scarlett = Game.createMonster("Scarlett Etzel", cPosition)
			if scarlett then
				scarlett:registerEvent('scarlettThink')
				scarlett:addHealth(-(scarlett:getMaxHealth()-cHealth))
			end
		end
	end, 200, creature:getId(), attacker:getId())
	SCARLETT_MAY_DIE = 0
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end