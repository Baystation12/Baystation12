// Server startup. Please proceed to the Lobby.
/world/TgsInitializationComplete()
	. = ..()
	var/announce_runwaiters = GLOB.last_played_date != time2text(world.realtime, "DD-MM-YYYY")
	var/name = GLOB.using_map.full_name
	var/datum/tgs_message_content/message = new ("**Дорогие <@&[ROUNDWAITERROLEID]>[announce_runwaiters ? " и <@&[RUNWAITERROLEID]>" : ""], заходите к нам -** <[get_world_url()]>")
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	embed.title = "Начинается смена на [name]"
	embed.description = "Вы можете кликнуть \[cюда\]([NON_BYOND_URL]), на фразу \"Сервер 'PRX'\" любого сообщения от меня, чтобы зайти на сервер."
	embed.colour = "#6590fe"
	embed.author = new /datum/tgs_chat_embed/provider/author/glob("Сервер 'PRX'")
	//embed.footer = new /datum/tgs_chat_embed/footer("Сервер 'PRX'")
	//embed.url = NON_BYOND_URL
	send2chat(message, "launch-alert")

// The round has been ended
/hook/roundend/proc/SendTGSRoundEnd()
	var/list/data = GLOB.using_map.roundend_statistics()
	var/name = GLOB.using_map.full_name
	var/datum/tgs_message_content/message = new ("")
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	embed.title = "Раунд на [name] завершен"
	embed.colour = "#fffb00"
	embed.author = new /datum/tgs_chat_embed/provider/author/glob("Сервер 'PRX'")
	//embed.footer = new /datum/tgs_chat_embed/footer("Сервер 'PRX'")
	//embed.url = NON_BYOND_URL

	if (data != null)
		embed.description = "Статистика подготовлена"
		var/datum/tgs_chat_embed/field/clients = new ("Всего игроков", "[data["clients"]]")
		var/datum/tgs_chat_embed/field/survHuman = new ("Выжило экипажа", "[data["surviving_humans"]]")
		var/datum/tgs_chat_embed/field/survTotal = new ("Выжило органиков", "[data["surviving_total"]]")	//required field for roundend webhook!
		var/datum/tgs_chat_embed/field/ghosts = new ("Наблюдателей", "[data["ghosts"]]")	//required field for roundend webhook!
		var/datum/tgs_chat_embed/field/evacHuman = new ("Эвакуировано экипажа", "[data["escaped_humans"]]")
		var/datum/tgs_chat_embed/field/evacTotal = new ("Эвакуировано органиков", "[data["escaped_total"]]")
		var/datum/tgs_chat_embed/field/left = new ("Брошены на произвол судьбы", "[data["left_behind_total"]]")	//players who didnt escape and aren't on the station.
		var/datum/tgs_chat_embed/field/survMisc = new ("Выжило не членов экипажа", "[data["offship_players"]]")
		clients.is_inline = TRUE
		survHuman.is_inline = TRUE
		survTotal.is_inline = TRUE
		ghosts.is_inline = TRUE
		//evacHuman.is_inline = TRUE
		evacTotal.is_inline = TRUE
		//left.is_inline = TRUE
		survMisc.is_inline = TRUE
		embed.fields = list(survHuman, survTotal, evacHuman, evacTotal, left, survMisc, clients, ghosts)
	else
		embed.description = "Статистики нет"

	send2chat(message, "launch-alert")

	if (LAZYLEN(GLOB.round_end_notifiees))
		send2chat(new /datum/tgs_message_content("*Раунд закончился, ребятки. Всем по слапу!*\n[GLOB.round_end_notifiees.Join(", ")]"), "bot-spam")
	return TRUE

/hook/banned/proc/SendTGSBan(bantype, admin, target, jobs, duration, reason)
	var/datum/tgs_message_content/message = new ("")
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	var/datum/tgs_chat_embed/field/Fadmin	= new ("Администратор", "[admin]")
	var/datum/tgs_chat_embed/field/Ftarget	= new ("Забаненный", "[target]")
	var/datum/tgs_chat_embed/field/Freason	= new ("Причина", "[reason]")
	Fadmin.is_inline = TRUE
	Ftarget.is_inline = TRUE
	embed.fields = list(Ftarget, Fadmin)
	embed.colour = "#ff0000"
	embed.author = new /datum/tgs_chat_embed/provider/author/glob("Сервер 'PRX'")
	//embed.footer = new /datum/tgs_chat_embed/footer("Сервер 'PRX'")
	//embed.url = NON_BYOND_URL

	switch(bantype)
		if (BANTYPE_JOB_PERMA)
			embed.title = "ПЕРМАНЕНТНАЯ ВРЕМЕННАЯ БЛОКИРОВКА ПРОФЕССИЙ"
			embed.description = "Пользователь потерял эти роли навсегда"
			var/datum/tgs_chat_embed/field/Fjobs = new ("Заблокированные профессии", "[jobs]")
			embed.fields += Fjobs
		if (BANTYPE_JOB_TEMP)
			embed.title = "ВРЕМЕННАЯ БЛОКИРОВКА ПРОФЕССИЙ"
			embed.description = "Пользователь потерял эти роли на время"
			var/datum/tgs_chat_embed/field/Ftime = new ("Длительность", "[duration]")
			var/datum/tgs_chat_embed/field/Fjobs = new ("Заблокированные профессии", "[jobs]")
			Ftime.is_inline = TRUE
			embed.fields += Ftime
			embed.fields += Fjobs
		if (BANTYPE_PERMA)
			embed.title = "ПЕРМАНЕНТНАЯ БЛОКИРОВКА"
			embed.description = "Пользователь был забанен навсегда"
		if (BANTYPE_TEMP)
			embed.title = "ВРЕМЕННАЯ БЛОКИРОВКА"
			embed.description = "Пользователь был забанен на время"
			var/datum/tgs_chat_embed/field/Ftime = new ("Длительность", "[duration]")
			Ftime.is_inline = TRUE
			embed.fields += Ftime
		else
			embed.title = "Странный бан"
			embed.description = "Забанил так забанил..."

	embed.fields += Freason
	send2chat(message, "notes-hub")
	return TRUE

/hook/unbanned/proc/SendTGSUnBan(admin, target)
	var/datum/tgs_message_content/message = new ("")
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	var/datum/tgs_chat_embed/field/Fadmin	= new ("Покровитель", "[admin]")
	var/datum/tgs_chat_embed/field/Ftarget	= new ("Помилованный", "[target]")
	Fadmin.is_inline = TRUE
	Ftarget.is_inline = TRUE
	embed.fields = list(Ftarget, Fadmin)
	embed.colour = "#00ff00"
	embed.title = "Амнистия"
	embed.author = new /datum/tgs_chat_embed/provider/author/glob("Сервер 'PRX'")
	//embed.footer = new /datum/tgs_chat_embed/footer("Сервер 'PRX'")
	//embed.url = NON_BYOND_URL

	send2chat(message, "notes-hub")
	return TRUE

/hook/playerNotes/proc/SendTGSNotes(admin, target, note)
	if (findtext_char(note, "banned") || findtext_char(note, "(MANUAL BAN)"))
		return TRUE		// Это бан (или может быть анбан), нефиг дублировать

	var/datum/tgs_message_content/message = new ("")
	var/datum/tgs_chat_embed/structure/embed = new()
	message.embed = embed
	var/datum/tgs_chat_embed/field/Fadmin	= new ("Доносчик", "[admin]")
	var/datum/tgs_chat_embed/field/Ftarget	= new ("Обвиняемый", "[target]")
	var/datum/tgs_chat_embed/field/Freason	= new ("Доносик", "[note]")
	Fadmin.is_inline = TRUE
	Ftarget.is_inline = TRUE
	embed.fields = list(Ftarget, Fadmin, Freason)
	embed.colour = "#e1ff00"
	embed.author = new /datum/tgs_chat_embed/provider/author/glob("Сервер 'PRX'")
	//embed.footer = new /datum/tgs_chat_embed/footer("Сервер 'PRX'")
	//embed.url = NON_BYOND_URL

	send2chat(message, "notes-hub")
	return TRUE

/hook/oocMessage/proc/SendOOCMsg(ckey, message, admin_rank)
	if (findtext_char(message, "@"))
		var/mob/M = get_mob_by_key(ckey)
		if(!M || !M.client || M.client.holder || M.client.deadmin_holder)
			message_admins("Говно - [ckey] пытался сделать слап. Но я не могу его замутить")
			return TRUE
		if(!(M.client.prefs.muted & MUTE_OOC))
			M.client.prefs.muted |= MUTE_OOC
			message_admins("Кусок абузера на [ckey] пытался сделать слап. Теперь у него нет ООС")
		return TRUE
	send2chat(new /datum/tgs_message_content("**[admin_rank == null ? null : admin_rank][ckey]:** *[replacetext_char(replacetext_char(message, "&#39;", "'"), " &#34;", "\"")]*"), "ooc-chat")
	return TRUE



// Max online notifier
var/max_client = 0
var/timer = null

/client/New()
	. = ..()
	max_client = max(max_client, GLOB.clients.len)

/hook/roundstart/proc/round_status_notifier()
	send2chat(new /datum/tgs_message_content("**Раунд начался!**\nКоличество экипажа: [GLOB.clients.len].[max_client != GLOB.clients.len ? " А ведь их было [max_client]!":""]"), "launch-alert")
	timer = addtimer(CALLBACK(GLOBAL_PROC, .proc/gen_report), 25 MINUTES, TIMER_UNIQUE | TIMER_STOPPABLE | TIMER_LOOP)
	return TRUE

/proc/gen_report()
	max_client = max(max_client, GLOB.clients.len)
	send2chat(new /datum/tgs_message_content("**Отчет по раунду.**\n__Продолжительность:__ *[roundduration2text()]*\n__Онлайн:__ *[GLOB.clients.len]*\n__Пиковый онлайн:__ *[max_client]*"), "launch-alert")

/hook/roundend/proc/round_status_notifier()
	deltimer(timer)
	timer = null
	return TRUE
