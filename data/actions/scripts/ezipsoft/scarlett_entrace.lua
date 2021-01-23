function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local isOutsideBossArea = isInRange(player:getPosition(), Position(33394, 32667, 6), Position(33396, 32668, 6))
	player:teleportTo(isOutsideBossArea and Position(33395, 32665, 6) or Position(33395, 32669, 6))
	return true
end