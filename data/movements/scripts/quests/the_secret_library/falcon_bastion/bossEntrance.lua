function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	if creature:getStorageValue(Storage.secretLibrary.FalconBastion.oberonTimer) <= os.stime() then
		creature:teleportTo(Position(33359, 31340, 9), true)
	else
		creature:teleportTo(fromPosition, true)
		creature:sendCancelMessage('You are still exhausted from your last battle.')
	end
end
