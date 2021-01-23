function onUse(player, item, fromPosition, itemEx, toPosition)
	local newItem = item:getId() + 1
	item:transform(newItem > 36312 and 36309 or newItem)
	item:getPosition():sendMagicEffect(CONST_ME_POFF)
    return true
end