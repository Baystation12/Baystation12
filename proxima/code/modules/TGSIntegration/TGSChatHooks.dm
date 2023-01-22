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

/hook/banned/proc/SendTGSBan(bantype, admin, target, jobs, duration, reason)
	var/bantypeString = ""
	switch(bantype)
		if (BANTYPE_JOB_PERMA)
			bantypeString = "*__**ПЕРМА ДЖОБКА НА ПРОФЫ:**__ \n[jobs]*"
		if (BANTYPE_JOB_TEMP)
			bantypeString = "*__Временно на профы:__ \n[jobs]*\n**5.1. Бан спадет через:** __*[duration]*__"
		if (BANTYPE_PERMA)
			bantypeString = "__***ПЕРМА***__"
		if (BANTYPE_TEMP)
			bantypeString = "__*На время*__.\n**5.1. Бан спадет через:** __*[duration]*__"
		else
			bantypeString = "__***капец как забанил...***__"
	send2chat("***Новый жбан***\n**1. Ckey осужденного:** __*[target]*__\n**2. Ckey администратора:** __*[admin]*__\n**3. Сервер:** __*PRX*__\n**4. Причина:**```[reason]```**5. Наказание и длительность:** [bantypeString]", "notes-hub")
	return TRUE

/hook/unbanned/proc/SendTGSUnBan(admin, target)
	send2chat("***Амнистия***\n__**1. Ckey помилованного:** __*[target]*__\n**2. Ckey покровителя:** __*[admin]***__**3. Сервер:** __*PRX*__\n**", "notes-hub")
	return TRUE

/hook/playerNotes/proc/SendTGSNotes(admin, target, note)
	send2chat("***Доносики***\n**1. Ckey обвиняемого:** __*[target]*__\n**2. Ckey доносчика:** __*[admin]*__\n**3. Сервер:** __*PRX*__\n**4. Доносик:** __*[note]*__\n**5. Тип:** __*Нотес (стаффварны не поддерживаются)*__\n**6. Срок действия доноса:** __*INFINITY (а как иначе то?)*__", "notes-hub")
	return TRUE

/hook/oocMessage/proc/SendOOCMsg(ckey, message, admin_rank)
	if (findtext_char(message, "@"))
		var/mob/M = get_mob_by_key(ckey)
		if(!M || !M.client || M.client.holder)
			message_admins("Говно - [ckey] пытался сделать слап. Но я не могу его замутить")
			return TRUE
		if(!(M.client.prefs.muted & MUTE_OOC))
			M.client.prefs.muted |= MUTE_OOC
			message_admins("Кусок абузера на [ckey] пытался сделать слап. Теперь у него нет ООС")
		return TRUE
	send2chat("**[admin_rank == null ? null : admin_rank][ckey]:** *[message]*", "ooc-chat")
	return TRUE
