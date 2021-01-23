function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local monsterId = ScarlettBossFight.room.monsterId
	local creature = Creature(monsterId)
	if not creature then
		return false
	end

	ScarlettBossFight:changeBlindStatus()

	addEvent(
		function(ScarlettBossFight)
			local monsterId = ScarlettBossFight.room.monsterId
			local creature = Creature(monsterId)
			if creature and ScarlettBossFight:isBlinded() then
				ScarlettBossFight:changeBlindStatus()
			end
		end, 10 * 1000, ScarlettBossFight
	)

	creature:say("Galthen... is that you?", TALKTYPE_MONSTER_SAY)
	creature:getPosition():sendMagicEffect(CONST_ME_THUNDER)

	item:remove()
	
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You hold the old chestplate of Galthen in front of you, it does not fit and is far too old to withstand any attack.")
	return true
end