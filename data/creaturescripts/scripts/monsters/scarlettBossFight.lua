local area = createCombatArea(arr)
local combat = Combat()
combat:setArea(createCombatArea(AREA_CIRCLE3X33))

function onTargetTile(creature, pos)
    local creatureTable = { }
	local tile = Tile(pos)
	if tile then
		local tileCreatures = tile:getCreatures()
		if tileCreatures and #tileCreatures > 0 then
			for _, tmpCreature in ipairs(tileCreatures) do 
				if tmpCreature ~= creature then
					table.insert(creatureTable, tmpCreature:getId())
				end
			end
		end
	end

	if #creatureTable ~= 0 then
		for _, creatureId in ipairs(creatureTable) do 
			local tmpCreature = Creature(creatureId)
			if tmpCreature and tmpCreature:isMonster() then
				doTargetCombatHealth(creature, tmpCreature, COMBAT_POISONDAMAGE, -7500, -7500)
			end
		end
	end

    pos:sendMagicEffect(CONST_ME_POISONAREA)
    return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local bossIsBlinded = ScarlettBossFight:isBlinded()
	if bossIsBlinded then
		if ScarlettBossFight:onCheckPillars() then
			ScarlettBossFight:changeBlindStatus()
			ScarlettBossFight:randomizeMirrors()

			creature:say("Aaaaaaah!!!", TALKTYPE_MONSTER_SAY)
			return -7500, COMBAT_DROWNDAMAGE, 0, COMBAT_DROWNDAMAGE
		end
	end

	combat:execute(creature, positionToVariant(creature:getPosition()))

	addEvent(
		function(creatureId)
			local creature = Creature(creatureId)
			if creature then
				creature:addHealth(5000)
			end
		end, 100, creature:getId()
	)

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
	ScarlettBossFight.room.activated = false
	ScarlettBossFight.room.canReceiveDamage = false
	ScarlettBossFight.room.monsterId = 0

	creature:say("Where... have you been all that time? Aaaaaaah!!!", TALKTYPE_MONSTER_SAY)
	return true
end