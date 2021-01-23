local decayItems = {
	[1945] = 1946, [1946] = 1945
}
local slots = {
	-- aqui sao os slots da esteira, por onde os itens vao ir passando... podem ser adicionados quantos quiser...
	Position(32351, 32218, 7),Position(32352, 32218, 7), Position(32353, 32218, 7), Position(32354, 32218, 7), Position(32355, 32218, 7)
}

local itemtable = {
	--aqui pode ter ate 100 itens.. a chance nunca pode se repetir, ela deve ser de 1 a 100...
	-- inserir os itens respeitando a ordem: [1], [2], [3], ...  ate o ultimo [100] (32477, 32378, 5)
	[1] = {id = 30678, chance = 1}, -- roullet ticket
	[2] = {id = 24331, chance = 2}, -- addon doll
	[3] = {id = 2504, chance = 10}, -- dwarven legs
	[4] = {id = 2499, chance = 15},-- amazon hhelmet
	[5] = {id = 2494, chance = 20}, -- d armor
	[6] = {id = 2472, chance = 25}, --mpa
	[7] = {id = 2470, chance = 30}, --g legs
	[8] = {id = 2492, chance = 35}, --dsm
	[9] = {id = 2466, chance = 40}, --garmor
	[10] = {id = 13166, chance = 45}, --demon doll
	[11] = {id = 2472, chance = 50},
	[12] = {id = 26132, chance = 55},
	[13] = {id = 13826, chance = 60},
	
	
	[14] = {id = 23810, chance = 95},
	[15] = {id = 5015, chance = 99}
}

local function ender(cid, position)
	local player = Player(cid)
	local posicaofim = Position(32354, 32218, 7) -- AQUI VAI APARECER A SETA, que define o item que o player ganhou
	local item = Tile(posicaofim):getTopDownItem()
	if item then
		local itemId = item:getId()
		posicaofim:sendMagicEffect(CONST_ME_TUTORIALARROW)
		player:addItem(itemId, 1)
	end
	local alavanca = Tile(position):getTopDownItem()
	if alavanca then
		alavanca:setActionId(33333) -- aqui volta o actionid antigo, para permitir uma proxima jogada...
	end
	if itemId == 30678 or itemId == 24331 then --checar se é o ID do item LENDARIO
		broadcastMessage("O player "..player:getName().." ganhou "..item:getName().."", MESSAGE_EVENT_ADVANCE) -- se for item raro mandar no broadcast
		
		for _, pid in ipairs(getPlayersOnline()) do
			if pid ~= cid then
				pid:say("O player "..player:getName().." ganhou "..item:getName().."", TALKTYPE_MONSTER_SAY) -- se nao for lendario, mandar uma mensagem comum
			end
		end
	end
end

local function delay(position, aux)
	local item = Tile(position):getTopDownItem()
	if item then
		local slot = aux + 1
		item:moveTo(slots[slot])
	end	
end

local function exec(cid)
	--calcular uma chance e atribuir um item
	local rand = math.random(1, 100)
	local aux, memo = 0, 0
	if rand >= 1 then
		for i = 1, #itemtable do
			local randitemid = itemtable[i].id
			local randitemchance = itemtable[i].chance
			if rand >= randitemchance then
				aux = aux + 1
				memo = randitemchance
			end
			
		end
	end
	-- Passo um: Criar um item no primeiro SLOT, e deletar se houver o item do ultimo slot.
	Game.createItem(itemtable[aux].id, 1, slots[1])
	slots[1]:sendMagicEffect(CONST_ME_THUNDER)
	local item = Tile(slots[#slots]):getTopDownItem()
	if item then
		item:remove()
	end
	--Passo dois: Mover itens para o proximo slot em todos os slots de 1 a 12 para o 2 > 13
	local maxslot = #slots-1
	local lastloop = 0
	for i = 1, maxslot do
		
		addEvent(delay, 1*1*60, slots[i], i)
	end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	if not player then
		return false
	end
	if not player:removeItem(2160, 35) then -- PARA JOGAR o player precisa ter o item 5091, que representa um bilhete vendido na store ou em um npc....
		return false
	end
	
	item:transform(decayItems[item.itemid])
	item:decay()	
	--muda actionid do item para nao permitir executar duas instancias
	item:setActionId(33334)
	
	local segundos = 20
	local loopsize = segundos*2
	
	for i = 1, loopsize do
		addEvent(exec, 1*i*500, cid.uid)
	end
	addEvent(ender, (1*loopsize*500)+1000, cid.uid, fromPosition)
	
	return true
end
