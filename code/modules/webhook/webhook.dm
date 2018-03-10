/proc/webhook_send_roundstatus(var/status, var/extraData)
	var/list/query = list("status" = status)

	if(extraData)
		query.Add(extraData)

	webhook_send("roundstatus", query)

/proc/webhook_send_asay(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("asaymessage", query)

/proc/webhook_send_ooc(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("oocmessage", query)

/proc/webhook_send_me(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("memessage", query)

/proc/webhook_send_ahelp(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("ahelpmessage", query)

/proc/webhook_send_garbage(var/ckey, var/message)
	var/list/query = list("ckey" = ckey, "message" = message)
	webhook_send("garbage", query)

/proc/webhook_send_token(var/ckey, var/token)
	var/list/query = list("ckey" = ckey, "token" = token)
	webhook_send("token", query)

/proc/webhook_send(var/method, var/data)
	if(!webhook_address || !webhook_key)
		return
	var/query = "[webhook_address]?key=[webhook_key]&method=[method]&data=[url_encode(json_encode(data))]"
	spawn(-1)
		world.Export(query)