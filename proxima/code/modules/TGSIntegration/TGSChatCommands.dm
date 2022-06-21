#define IRC_STATUS_THROTTLE 5

/datum/tgs_chat_command/ircstatus
	name = "status"
	help_text = "Показывает админов, кол-во игроков, игровой режим и настоящий игровой режим на сервере"
	admin_only = TRUE
	var/last_irc_status = 0

/datum/tgs_chat_command/ircstatus/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_status < IRC_STATUS_THROTTLE)
		return
	last_irc_status = rtod
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "**Админы: [allmins.len]**\nАктивные: __*[english_list(adm["present"])]*__\nАФК: __*[english_list(adm["afk"])]*__\nСкрыты: __*[english_list(adm["stealth"])]*__\nБез бана: __*[english_list(adm["noflags"])]*__\n\n"
	status += "**Игроки: [GLOB.clients.len]**\nАктивные: `[get_active_player_count(0,1,0)]`\nПубличный режим: ||__*[PUBLIC_GAME_MODE]*__||\nНастоящий режим: ||__*[SSticker.mode ? SSticker.mode.name : "Не начался"]*__||"
	return status

/datum/tgs_chat_command/irccheck
	name = "check"
	help_text = "Показывает онлайн, текущий режим и адрес сервера"
	var/last_irc_check = 0

/datum/tgs_chat_command/irccheck/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_check < IRC_STATUS_THROTTLE)
		return
	last_irc_check = rtod
	return "[game_id ? "**Раунд №** `[game_id]`\n" : ""]Игроков: `[GLOB.clients.len]`\nКарта: __[GLOB.using_map.full_name]__\nРежим: ||__[PUBLIC_GAME_MODE]__||\nРаунд: __[GAME_STATE != RUNLEVEL_LOBBY ? (GAME_STATE != RUNLEVEL_POSTGAME ? "Активен" : "Заканчивается") : "Подготавливается"]__\n**Заходи к нам: <[get_world_url()]>**"

/datum/tgs_chat_command/ircmanifest
	name = "manifest"
	help_text = "Показывает список членов экипажа с их должностями"
	var/last_irc_check = 0

/datum/tgs_chat_command/ircmanifest/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_check < IRC_STATUS_THROTTLE)
		return
	last_irc_check = rtod

	if(GAME_STATE == RUNLEVEL_LOBBY)
		return "Раунд еще подготавливается..."

	var/list/msg = list()
	var/list/positions = list()
	var/list/nano_crew_manifest = nano_crew_manifest()
	// We rebuild the list in the format external tools expect
	for(var/dept in nano_crew_manifest)
		var/list/dept_list = nano_crew_manifest[dept]
		if(dept_list.len > 0)
			positions[dept] = list()
			var/depString
			switch(dept)
				if ("heads") depString = "Командование"
				if ("spt") depString = "Поддержка командования"
				if ("sci") depString = "Научный отдел"
				if ("sec") depString = "Отдел безопасности"
				if ("eng") depString = "Инженерный отдел"
				if ("med") depString = "Медицинский отдел"
				if ("sup") depString = "Отдел снабжения"
				if ("exp") depString = "Экспедиционный отдел"
				if ("srv") depString = "Отдел обслуживания"
				if ("bot") depString = "Синтетики"
				if ("civ") depString = "Гражданские"
				else depString = dept
			msg += "__**[depString]**__"
			for(var/list/person in dept_list)
				var/datum/mil_branch/branch_obj = mil_branches.get_branch(person["branch"])
				var/datum/mil_rank/rank_obj = mil_branches.get_rank(person["branch"], person["milrank"])
				msg += "*[person["rank"]]* - `[branch_obj != null ? "[branch_obj.name_short] " : ""][((rank_obj != null) && (rank_obj.name_short != "")) ? "[rank_obj.name_short] " : ""][replacetext_char(person["name"], "&#39;", "'")]`"
	return jointext(msg, "\n")

/** -- Отвечать на тикеты из дискорда? Я подумаю над этим
/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = ""
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Insufficient parameters"
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return "Ticket #[id] not found!"
	var/res = IrcPm(target, all_params.Join(" "), sender.friendly_name)
	if(res != "Message Successful")
		return res
**/

/datum/tgs_chat_command/adminwho
	name = "adminwho"
	help_text = "Перечисляет администраторов, находящихся на сервере"

/datum/tgs_chat_command/adminwho/Run(datum/tgs_chat_user/sender, params)
	var/list/msg = list()
	var/active_staff = 0
	var/total_staff = 0
	var/can_investigate = sender.channel.is_admin_channel

	for(var/client/C in GLOB.admins)
		var/line = list()
		if(!can_investigate && C.is_stealthed())
			continue
		total_staff++
		if(check_rights(R_ADMIN,0,C))
			line += "*[C]* в ранге ***["\improper[C.holder.rank]"]***"
		else
			line += "*[C]* в ранге *["\improper[C.holder.rank]"]*"
		if(!C.is_afk())
			active_staff++
		if(can_investigate)
			if(C.is_afk())
				line += " *(АФК - [C.inactivity2text()])*"
			if(isghost(C.mob))
				line += " - *Наблюдает*"
			else if(istype(C.mob,/mob/new_player))
				line += " - *В Лобби*"
			else
				line += " - *Играет*"
			if(C.is_stealthed())
				line += " *(Скрыт)*"
		line = jointext(line, null)
		if(check_rights(R_ADMIN,0,C))
			msg.Insert(1, line)
		else
			msg += line
	return "__**Админов онлайн: [can_investigate?"[active_staff]/[total_staff]":"[active_staff]"]**__\n[jointext(msg,"\n")]"

GLOBAL_LIST(round_end_notifiees)

/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "Уведомляет вызвавшего по окончанию раунда"
	//admin_only = TRUE

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	if(GAME_STATE == RUNLEVEL_POSTGAME)
		return "[sender.mention], раунд уже закончился!"
	LAZYINITLIST(GLOB.round_end_notifiees)
	GLOB.round_end_notifiees[sender.mention] = TRUE
	return "Я уведомлю [sender.mention] когда раунд закончится."

/datum/tgs_chat_command/fax
	name = "fax"
	help_text = "Используется для просмотра, создания и овтетов на факсы. Используйте без параметров для помощи"
	admin_only = TRUE

/datum/tgs_chat_command/fax/Run(datum/tgs_chat_user/sender, params)
	var/textTrue = copytext_char(params, findtext_char(params, "```"))
	if (textTrue!=null && textTrue!="")
		params = replacetext_char(params, textTrue, "")
		textTrue = replacetext_char(textTrue, "```", "")
	var/list/tmpList = splittext_char(params, " ")
	var/command = tmpList.len ? tmpList[1] : null
	if (command == null || command == "")
		return "Дорогой [sender.mention], пожалуйста, ознакомься с тем как использовать эту команду.\n\nИспользование `fax комманда, аргументы(через запятую!!!)`\n\n__Команды:__\n\n1. **view \[ID\]** - без *ID* показывает список факсов полученных админами и посланных. С *ID* - показывает конкретный факс и его данные.\n\n2. **send \[\[FROM\] \[DESTINATION\] \[TITLE\] \[STAMP\] \[LANGUAGE\] \[HEADER_LOGO\] \[FOOTER\] \[PEN_MODE\] \[TEXT\]\]** - без аргументов - получить подсказку по написанию факсов, в том числе доступные __адреса для отправки__. С параметрами - написать факс все аргументы обязательны:\n*DESTINATION* - куда отправить факс (адрес должен существовать)\n*FROM* - от кого, ЦК, НаноТрейзн, Родная и любимая Бабушка - все что угодно\n*TITLE* - заголовок для факса\n*STAMP* - нужна ли печать (учтите печать принадлежит адресату то есть может быть 'Печать Квантового Реле Родной и любимой Бабушки'. Значения `TRUE`/`FALSE` или 1/0\n*LANGUAGE* - язык на котором написан факс, должен быть в списке\n*HEADER_LOGO* - логотип для заголовка. Так же может быть в значении `EMPTY` для заголовка без логотипа и `NULL` для факса без заголовка\n*FOOTER* - нужен ли мелкий текст (...уведомите отправителя и ЦК если хешключ не совпададает ля-ля...) значения `TRUE`/`FALSE` или 1/0\n*PEN_MODE* - зачем вы пишите факс мелком? Вы клоуны? Значения `PEN`/`CRAYON`\n*TEXT* - сообственно текст факса. Форматирование такое же как и в игре, НО перед текстом и после него добавьте ```\n\n*Использование тэга \[field\] недоступно.*"
	else
		params = copytext_char(params, length_char(command)+1)
	var/list/parampampam = splittext_char(params, ", ")

	// Копируем инфомрацию по логотипам из /obj/item/paper/admin
	var/obj/item/paper/admin/adminPaper = new /obj/item/paper/admin( null )
	var/list/logo_list = adminPaper.logo_list
	logo_list = logo_list.Copy()
	QDEL_IN(adminPaper, 100)

	switch(command)
		// Просмотр факсов
		if("view")
			// Без аргументов
			if(parampampam.len == 0)
				if(GLOB.adminfaxes && GLOB.adminfaxes.len)
					var/list/msg = list()
					msg += "**Вот доступные факсы:**"
					for(var/i = 1, i <= GLOB.adminfaxes.len, i++)
						var/obj/item/obj = GLOB.adminfaxes[i]
						msg += "№ `[i]` | [obj.name]"
					return jointext(msg, "\n")
				else
					return "В этом раунде факсов для админов не было"
			// С айди, и айди существует
			else if(text2num(parampampam[1]) != null && text2num(parampampam[1]) <= GLOB.adminfaxes.len)
				var/obj/item/item = GLOB.adminfaxes[text2num(parampampam[1])]
				if (istype(item, /obj/item/paper))
					return paper2text(item)

				else if (istype(item, /obj/item/photo))
					return photo2text(item)

				else if (istype(item, /obj/item/paper_bundle))
					var/list/pack = bundle2text(item)
					var/i = 0
					for(var/string in pack)
						i += 10
						addtimer(CALLBACK(world, /world/proc/TgsChatPrivateMessage, string, sender), i)
					return "Отправлено в личные сообщения [sender.mention]"

				else return "Не удалось определить тип факса. Это баг сообщите куда подальше. Тип факса `[item.type]`"
			// Нет факса с айди
			else return "Не удалось найти факс под номером № `[parampampam[1]]`"

		// Отправка факса
		if("send")
			// Без аргументов - подсказка
			if(parampampam.len == 0)
				var/list/msg = list()
				msg += "__**Помощь по адресам и логотипам**__"
				msg += "__*Доступные логотипы:*__ NULL | EMPTY | [jointext(logo_list, " | ")]\n"
				var/list/selectable_languages = list()
				for (var/key in global.all_languages)
					var/datum/language/L = global.all_languages[key]
					if (L.has_written_form)
						selectable_languages += L.name
				msg += "__*Доступные языки:*__ [jointext(selectable_languages, " | ")]\n"
				msg += "__*Доступные адресаты:*__ [jointext(GLOB.alldepartments, " | ")]"
				return jointext(msg, "\n")

			// Не хватает аргументов
			else if(parampampam.len < 8 || textTrue == null) return "Недостаточно кол-во аргументов. Требуется `8` (без send и текста) получено `[parampampam.len][textTrue == null?" и текст не найден":" и текст был найден"]`"
			// Отправка факса
			else
				var/from = parampampam[1]
				var/destination = parampampam[2]
				var/title = parampampam[3]
				var/stamp = parampampam[4]
				var/language = parampampam[5]
				var/headerLogo = parampampam[6]
				var/footer = parampampam[7]
				var/penMode = parampampam[8]
				var/text = textTrue
				// PARAMS CHECK START

				// Destination
				var/list/reciever = list()
				for(var/obj/machinery/photocopier/faxmachine/sendto in GLOB.allfaxes)
					if (sendto.department == destination)
						reciever += sendto
				if(reciever.len == 0)
					return "Не удалось найти ни один факс по адресу `[destination]`"

				// Language
				var/datum/language/lang
				lang = global.all_languages[language]
				if(!lang)
					return "Не удалось найти указанный язык `[language]`"
				if(!lang.has_written_form)
					return "У языка `[language]` нет письменной формы. Укажите другой язык."

				// Header - Logo
				if (!(headerLogo in logo_list))
					if (!(headerLogo in list("NULL","EMPTY")))
						return "Не удалось найти логотип `[headerLogo]`"

				// Stamp
				if(stamp == "TRUE" || stamp == "1" || stamp == TRUE)
					stamp = TRUE
				else if(stamp == "FALSE" || stamp == "0" || stamp == FALSE)
					stamp = FALSE
				else return "Неизвестное состояние штампа `[stamp]`"

				// Footer
				if(footer == "TRUE" || footer == "1" || footer == TRUE)
					footer = TRUE
				else if(footer == "FALSE" || footer == "0" || footer == FALSE)
					footer = FALSE
				else return "Неизвестное состояние нижнего текста `[footer]`"

				// Pen Mode
				if(penMode == "PEN")
					penMode = TRUE
				else if(penMode == "CRAYON")
					penMode = FALSE
				else return "Неизвестное состояние ручки или мелка `[penMode]`"

				// Text
				var/t = sanitize(text, MAX_PAPER_MESSAGE_LEN, extra = 0)
				if(!t)
					return "Ваш текст был уничтожен санитайзером. GGWP"
				t = replacetext_char(t, "\n", "<BR>")
				t = replacetext_char(t, "\[field\]", "") // No fields sorry

				// PARAMS CHECK FINISH

				// Fax creation
				var/obj/item/paper/admin/adminfax = new /obj/item/paper/admin( null )
				adminfax.admindatum = null // May be it need to be reworked

				adminfax.set_language(lang, TRUE)	// Нужен только язык и Лого. Остальное, де факто - мусор
				adminfax.logo = headerLogo == "NULL" ? "" : headerLogo == "EMPTY" ? "" : headerLogo
				adminfax.origin = from
				adminfax.isCrayon = !penMode
				adminfax.headerOn = headerLogo != "NULL"
				adminfax.footerOn = footer
				adminfax.info = t

				// Это делается при отправке так или иначе
				adminfax.generateHeader()
				adminfax.generateFooter()
				adminfax.info = adminfax.parsepencode(adminfax.info, null, null, !penMode, null, TRUE) // Encode everything from pencode to html

				if (adminfax.headerOn)
					adminfax.info = adminfax.header + adminfax.info
				if (adminfax.footerOn)
					adminfax.info += adminfax.footer

				adminfax.SetName("[adminfax.origin] - [title]")
				adminfax.desc = "This is a paper titled '" + adminfax.name + "'."

				// Я не знаю зачем так сложно с печатью
				if (stamp)
					adminfax.stamps += "<hr><i>This paper has been stamped by the [adminfax.origin] Quantum Relay.</i>"

					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					var/x
					var/y
					x = rand(-2, 0)
					y = rand(-1, 2)
					adminfax.offset_x += x
					adminfax.offset_y += y
					stampoverlay.pixel_x = x
					stampoverlay.pixel_y = y

					if(!adminfax.ico)
						adminfax.ico = new
					adminfax.ico += "paper_stamp-boss"
					stampoverlay.icon_state = "paper_stamp-boss"

					if(!adminfax.stamped)
						adminfax.stamped = new
					adminfax.stamped += /obj/item/stamp/boss
					adminfax.overlays += stampoverlay

				// А вы знали, что когда админ печатает вам факс, то копия которая сохраняется в админских датумах так же жрет тоннер?
				var/obj/item/rcvdcopy
				var/obj/machinery/photocopier/faxmachine/cloner = pick(reciever)
				rcvdcopy = cloner.copy(adminfax)
				rcvdcopy.forceMove(null) //hopefully this shouldn't cause trouble
				GLOB.adminfaxes += rcvdcopy

				var/list/failure = list()
				var/list/success = list()
				for (var/obj/machinery/photocopier/faxmachine/machine in reciever)
					if (machine.recievefax(adminfax))
						success += machine.department
					else
						failure += machine.department

				QDEL_IN(adminfax, 100 * reciever.len)

				return "[success.len == 0 ? "Факс не удалось доставить до адресата (сломан/обесточен)" : failure.len == 0 ? "Факс успешно доставлен до всех адресатов" : "Факс был *доставлен* до: [jointext(success, ", ")]\nФакс *не был доставлен* до [jointext(failure, ", ")] - (сломан/обесточен)"]"
		else
			// Я могу только прочитать или написать факс
			return "Не удалось распознать аргумент `[parampampam[1]]`"
