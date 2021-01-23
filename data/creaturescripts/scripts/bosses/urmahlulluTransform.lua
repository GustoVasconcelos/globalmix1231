function onThink(creature)
	if creature:getName():lower() ~= 'Urmahlullu the Immaculate' then
		return true
	end
	if creature:getMaxHealth() == 100000 then
		if creature:getHealth() <= 50000 then
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
			Game.createMonster('Wildness of Urmahlullu', creature:getPosition(), true, true)
			creature:remove()
		end
	end
	if creature:getMaxHealth() == 50000 then
		if creature:getHealth() <= 25000 then
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
			local urmahlullu = {
				[1] = {name = 'Urmahlullu the Tamed'},
				[2] = {name = 'Wisdom of Urmahlullu'}
			}
			Game.createMonster(urmahlullu[math.random(#urmahlullu)].name, creature:getPosition(), true, true)
			creature:remove()
		end
	end
end

function onDeath(creature, corpse, deathList)
	local pool = Tile(creature:getPosition()):getItemById(2016)
	if pool then
		pool:remove()
	end
	Game.createMonster("Urmahlullu the Weakened", creature:getPosition(), true, true)
end
