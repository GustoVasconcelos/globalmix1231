function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end
	player:teleportTo(Position(33385, 32627, 7))
	return true
end
