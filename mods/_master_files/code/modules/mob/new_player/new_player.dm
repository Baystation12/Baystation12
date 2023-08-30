/mob/new_player/Topic(href, href_list)
	if (usr != src)
		return TOPIC_NOACTION
	if (!client)
		return TOPIC_NOACTION

	if(href_list["ready"] || href_list["observe"] || href_list["late_join"])
		if(config.minimum_byondacc_age && client.player_age <= config.minimum_byondacc_age)
			if(!client.discord_id || (client.discord_id && length(client.discord_id) == 32))
				client.load_player_discord(client)
				to_chat(usr, "<span class='danger'>Вам необходимо привязать дискорд-профиль к аккаунту!</span>")
				to_chat(usr, "<span class='warning'>Нажмите 'Привязка Discord' во вкладке 'Special Verbs' для получения инструкций.</span>")
				return TOPIC_NOACTION

	return ..()
