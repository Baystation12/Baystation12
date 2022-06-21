// Server startup. Please proceed to the Lobby.
/world/TgsInitializationComplete()
	. = ..()
	var/name = GLOB.using_map.full_name
	send2chat("**Внимание, <@&839057002046947329>**\nНачинается смена на **[name]**.\n*Заходите на <[get_world_url()]>*", "launch-alert")

// The round has been ended
/hook/roundend/proc/SendTGSRoundEnd()
	var/list/data = GLOB.using_map.roundend_statistics()
	var/name = GLOB.using_map.full_name
	if (data != null)
		var/v1 = data["clients"]
		var/v2 = data["surviving_humans"]
		var/v3 = data["surviving_total"]//required field for roundend webhook!
		var/v4 = data["ghosts"] //required field for roundend webhook!
		var/v5 = data["escaped_humans"]
		var/v6 = data["escaped_total"]
		var/v7 = data["left_behind_total"] //players who didnt escape and aren't on the station.
		var/v8 = data["offship_players"]
		send2chat("**Раунд на [name] завершен.**\n__Статистика:__\n*Выжило экипажа: **[v2]** (из которых органиков: **[v3])***\n*Эвакуированно экипажа: **[v5]** (из которых органиков: **[v6]**)*\n*Выживший экипаж, но брошенный умирать: **[v7]***\n*Выжившие не члены экипажа: **[v8]***\n*Всего игроков: **[v1]** (из них наблюдателей: **[v4]**)*", "launch-alert")
	else
		send2chat("**Раунд на [name] завершен.**\n__Статистики нет.__", "launch-alert")

	if (LAZYLEN(GLOB.round_end_notifiees))
		send2chat("*Раунд закончился, ребятки. Всем по слапу!*\n[GLOB.round_end_notifiees.Join(", ")]", "bot-spam")
	return TRUE
