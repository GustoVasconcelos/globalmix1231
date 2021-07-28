--[[
	[57200] ={ 					-- actionid que será usado na pedra. Cada tipo de pedra terá uma actionid diferente.
		nameStone = "stone",	-- nome
		idStone = 1000,			-- id da pedra
		exStone = 1000,			-- id da pedra quando fica sem
		idItem = 1000,			-- id do item que ganhará ao minerar
		quantItem = 5,			-- quantas minérios vem por pedra
		premium = false,		-- true para apenas premium conseguir minerar determinada pedra
		time = 10,				-- tempo em segundos da progressbar
		progressbar = true 		-- se irá aparecer a progressbar enquanto minera
	}
]]--

mining_config = {	
	[57200] = {
		nameStone = "stone",
		idStone = 1285,
		exStone = 3608,
		idItem = 1294,
		quantItem = 5,
		premium = false,
		time = 6,
		progressbar = true
	}
}