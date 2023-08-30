/client
	var/discord_id = null
	var/discord_name = null

/client/proc/load_player_discord(client/C)
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(C.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT `discord_id`, `discord_name` FROM `erro_player` WHERE `ckey` = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		discord_id = sanitize_text(query.item[1])
		discord_name = sanitize_text(query.item[2])

/client/verb/link_discord_account()
	set name = "Привязка Discord"
	set category = "Special Verbs"
	set desc = "Привязать аккаунт Discord для удобного просмотра игровой статистики на нашем Discord-сервере."

	if(!config.discord_url)
		return

	if(IsGuestKey(key))
		to_chat(usr, "Гостевой аккаунт не может быть привязан.")
		return

	load_player_discord(usr)

	if(discord_id && length(discord_id) < 32)
		to_chat(usr, SPAN_CLASS("darkmblue", "Аккаунт Discord уже привязан! Чтобы отвязать используйте команду [SPAN_CLASS("boldannounce", "!отвязать_аккаунт")] в канале <b>#дом-бота</b> в Discord-сообществе!"))
		return

	var/token = md5("[world.time+rand(1000,1000000)]")
	if(dbcon.IsConnected())
		var/sql_ckey = sql_sanitize_text(ckey(key))
		var/DBQuery/query_update_token = dbcon.NewQuery("UPDATE `erro_player` SET `discord_id` = '[token]' WHERE `ckey` = '[sql_ckey]'")

		if(!query_update_token.Execute())
			to_chat(usr, "<span class='warning'>Ошибка записи токена в БД! Обратитесь к администрации.</span>")
			log_debug("link_discord_account: failed db update discord_id for ckey [ckey]")
			return

		to_chat(usr, SPAN_CLASS("darkmblue", "Для завершения используйте команду [SPAN_CLASS("boldannounce", "!привязать_аккаунт [token]")] в канале <b>#дом-бота</b> в Discord-сообществе!"))
		load_player_discord(usr)
