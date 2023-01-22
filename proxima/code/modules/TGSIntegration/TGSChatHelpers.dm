/**
sends a message to chat

config_setting should be one of the following:

- null - noop
- empty string - use TgsTargetBroadcast with `admin_only = FALSE`
- other string - use TgsChatBroadcast with the tag that matches config_setting, only works with TGS4, if using TGS3 the above method is used
*/
/proc/send2chat(message, config_setting)
	if(config_setting == null || !world.TgsAvailable())
		return

	var/datum/tgs_version/version = world.TgsVersion()
	if(config_setting == "" || version.suite == 3)
		world.TgsTargetedChatBroadcast(message, FALSE)
		return

	var/list/channels_to_use = list()
	for(var/I in world.TgsChatChannelInfo())
		var/datum/tgs_chat_channel/channel = I
		if(channel.custom_tag == config_setting)
			channels_to_use += channel

	if(channels_to_use.len)
		world.TgsChatBroadcast(message, channels_to_use)

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights(requiredflags, 0, X))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.is_stealthed())
			.["stealth"] += X
		else
			.["present"] += X

/proc/get_active_player_count(var/alive_check = 0, var/afk_check = 0, var/human_check = 0)
	// Get active players who are playing in the round
	var/active_players = 0
	for(var/i = 1; i <= GLOB.player_list.len; i++)
		var/mob/M = GLOB.player_list[i]
		if(M && M.client)
			if(alive_check && M.stat)
				continue
			else if(afk_check && M.client.is_afk())
				continue
			else if(human_check && !ishuman(M))
				continue
			else if(isnewplayer(M)) // exclude people in the lobby
				continue
			else if(isghost(M)) // Ghosts are fine if they were playing once (didn't start as observers)
				var/mob/observer/ghost/O = M
				if(O.started_as_observer) // Exclude people who started as observers
					continue
			active_players++
	return active_players

/proc/fax2TGS(var/o3, var/from3, var/to3, var/by3, var/intercepted3 = null)
	var/list/admins = get_admin_counts()["present"]
	var/obj/item/item = o3
	if(istype(item, /obj/item/paper))
		world.TgsTargetedChatBroadcast("[admins.len = 0 ? "<@&984927384513953852> активных админов с Банхамером нет\n" : null]__**Перехват факса**__[intercepted3 ? "\n***ФАКС БЫЛ ПЕРЕХВАЧЕН, ПОЛУЧАТЕЛЬ ЕГО __НЕ ВИДИТ__***: [intercepted3]":""]\n**ОТ:** __[from3]__\n**КУДА:** __[to3]__\n**ОТПРАВИЛ:** __[by3]__\n[paper2text(item)]", TRUE)
	else if (istype(item, /obj/item/photo))
		world.TgsTargetedChatBroadcast("[admins.len = 0 ? "<@&984927384513953852> активных админов с Банхамером нет\n" : null]__**Перехват факса**__[intercepted3 ? "\n***ФАКС БЫЛ ПЕРЕХВАЧЕН, ПОЛУЧАТЕЛЬ ЕГО __НЕ ВИДИТ__***: [intercepted3]":""]\n**ОТ:** __[from3]__\n**КУДА:** __[to3]__\n**ОТПРАВИЛ:** __[by3]__\n[photo2text(item)]", TRUE)
	else if (istype(item, /obj/item/paper_bundle))
		world.TgsTargetedChatBroadcast("[admins.len = 0 ? "<@&984927384513953852> активных админов с Банхамером нет\n" : null]__**Перехват факса**__[intercepted3 ? "\n***ФАКС БЫЛ ПЕРЕХВАЧЕН, ПОЛУЧАТЕЛЬ ЕГО __НЕ ВИДИТ__***: [intercepted3]":""]\n**ОТ:** __[from3]__\n**КУДА:** __[to3]__\n**ОТПРАВИЛ:** __[by3]__", TRUE)
		var/list/pack = bundle2text(item)
		var/i = 10
		for(var/string in pack)
			i += 10
			addtimer(CALLBACK(world, /world/proc/TgsTargetedChatBroadcast, string, TRUE), i)
	return TRUE

//
// Костыль для превращения факса в текст
/proc/paper2text(var/obj/item/paper/paper)
	. = list()
	. += "**Название:** [paper.name]"
	. += "**Язык написания:** [paper.language.name]"
	// TODO пропарсить HTML в разметку, принимаемую дискордом?
	. += "**Содержимое:**\n*Внимание - чистый HTML*\n```html\n[paper.info]```"
	. = jointext(., "\n")

// Костыль для превращения фото в текст
/proc/photo2text(var/obj/item/photo/photo)
	. = list()
	. += "__*Просмотр фото не может быть имплементирован, но вот некоторые данные о нем*__"
	. += "**Название:** [photo.name]"
	if(photo.scribble)
		. += "**Подпись с обратной стороны:** [photo.scribble]"
	. += "**Размер фото (в тайлах):** [photo.photo_size]X[photo.photo_size]"
	. += "**Описание:** [photo.desc == null ? "*Нет описания фото*" : photo.desc]"
	. = jointext(., "\n")

/proc/bundle2text(var/obj/item/paper_bundle/bundle)
	. = list()
	. += "__*Пачка документов*__"
	for (var/page = 1, page <= bundle.pages.len, page++)
		var/list/msg = list()
		msg += "===== Страница № `[page]` ====="
		var/obj/item/obj = bundle.pages[page]
		msg += istype(obj, /obj/item/paper) ? paper2text(obj) : istype(obj, /obj/item/photo) ? photo2text(obj) : "НЕИЗВЕСТНЫЙ ТИП БЮРОКРАТИЧЕСКОГО ОРУДИЯ ПЫТОК. ТИП: [obj.type]"
		msg += "--------------------------"
		. += jointext(msg, "\n")
	. += "__*Конец пачки документов*__"
