local talk = TalkAction("/progressbar")

function talk.onSay(player, words, param)
	local creature = player
	--player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, creature:getName())
	creature:sendProgressbar(10000, true)
end

talk:separator(" ")
talk:register()