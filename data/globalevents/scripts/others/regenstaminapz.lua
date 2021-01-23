function onThink(pid, interval, lastExecution, thinkInterval)
	local refuel = 42 * 60
    	local add = 4
   	for _, online in ipairs(Game.getPlayers()) do
		if online:isPlayer() then
            		if getTilePzInfo(online:getPosition()) and online:getStamina() < refuel then
                		online:setStamina(online:getStamina() + add)
				online:sendCancelMessage('[REGEN STAMINA] You gained 4 minutes of stamina in PZ Zone')
            		end
        	end
	end
	return true 
end