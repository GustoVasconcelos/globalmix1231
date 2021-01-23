starterQuest = 
{
	storage = 300000,

	vocations = 
	{
		[9500] = 
		{
			vocId = 1,
			containerId = 2000,
			items = 
			{
				{id = 10016, count = 1}, --batwing hat
				{id = 8871, count = 1}, --focus cape
				{id = 11304, count = 1}, --zaoan legs
				{id = 11303, count = 1}, --zaoan shoes
				{id = 2520, count = 1}, --demon shield
				{id = 8922, count = 1}, --wand of voodo	
				 
			}

		},

		[9501] = 
		{
			vocId = 2,
			containerId = 2000,
			items = 
			{
				{id = 10016, count = 1}, --batwing hat
				{id = 8871, count = 1}, --focus cape
				{id = 11304, count = 1}, --zaoan legs
				{id = 11303, count = 1}, --zaoan shoes
				{id = 2520, count = 1}, --demon shield
				{id = 8910, count = 1}, --underworld rod
			}

		},

		[9502] = 
		{
			vocId = 3,
			containerId = 2000,
			items = 
			{
				{id = 2497, count = 1}, --crusader helmet
				{id = 8891, count = 1}, --paladin armor
				{id = 11304, count = 1}, --zaoan legs
				{id = 11303, count = 1}, --zaoan shoes
				{id = 2520, count = 1}, --demon shield
				{id = 8855, count = 1}, --composite hornbow 
				{id = 8849, count = 1}, --modified crossbow
				{id = 2543, count = 1}, --bolt


			}

		},

		[9503] = 
		{
			vocId = 4,
			containerId = 2000,
			items = 
			{
				{id = 2497, count = 1}, --crusader helmet
				{id = 2466, count = 1}, --golden armor
				{id = 11304, count = 1}, --zaoan legs
				{id = 11303, count = 1}, --zaoan shoes
				{id = 2520, count = 1}, --demon shield
				{id = 7404, count = 1}, --Relic Sword 
				{id = 2424, count = 1}, --Silver Mace
				{id = 7411, count = 1}, --ornamented axe
			}

		}

	},

	allItems = --items pra all voctions
	{
		{id = 2160, count = 10}
	}
}
--[[10016--batwing hat
2497 --crusader helmet 

8891 --paladin armor
8871 --focus cape
2466 --golden armor

11304 --zaoan legs

24637 --oriental shoes

2520--demon shield


7404 --Relic Sword
2424 --Silver Mace
7411 --ornamented axe
8855 --composite hornbow 	
8849 --modified crossbow
8910 --underworld rod
8922 --wand of voodoo--]]


function starterQuest:giveItems(player, vocItems)
	if (player) then 

		local container = Game.createItem(vocItems.containerId, 1)
		local item
		for i = 1, #vocItems.items do 
			item = vocItems.items[i]
			container:addItem(item.id, item.count)
		end 

		for i = 1, #self.allItems do 
			item = self.allItems[i]
			container:addItem(item.id, item.count)
		end 

		if (player:addItemEx(container) == RETURNVALUE_NOERROR) then 
			return true
		end 
	end
end 

function starterQuest:execute(player, aid)
	if (player) then
		if (player:getStorageValue(self.storage) > 0) then 
			player:sendTextMessage(MESSAGE_INFO_DESCR, 'It is empty.')
			return false
		end 
		local quest = self.vocations[aid]
		if (quest) then 
			local vocId = player:getVocation():getBase():getId()
			if (vocId == quest.vocId) then 
				local giveItems = self:giveItems(player, quest)
				local msg = 'You have found a backpack  =D'
				if (not giveItems) then 
					msg = 'Be sure you have enough capacity.'
				else
					player:setStorageValue(self.storage, 1) 
				end 

				player:sendTextMessage(MESSAGE_INFO_DESCR, msg)

				return true
			else
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'This chest doesn\'t fit for your vocation.' )
				--print(vocId..'___'..quest.vocId)
			end
		else
			--print('error') 
		end 
	else
		--print('...')
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	--print('test')
	starterQuest:execute(player, item:getActionId())
	return true 
end 
