/// Webhooks for discord. CreateBody should
/singleton/webhook/discord
	abstract_type = /singleton/webhook/discord
	webhook_flags = WEBHOOK_REQUIRES_BODY

	/// Optional comma separated string of mentions.
	var/discord_mentions


/singleton/webhook/discord/Configure(list/details)
	if (!..(details))
		return FALSE
	var/list/mentions = details["mentions"]
	if (!mentions)
		discord_mentions = null
	if (islist(mentions))
		discord_mentions = jointext(mentions, ", ")
	else if (istext(mentions))
		discord_mentions = mentions
	return TRUE


/singleton/webhook/discord/CreateHeaders()
	return "{\"Content-Type\":\"application/json\"}"


/**
* Prepends mentions if they are configured.
* Data may be simply a content string, or a map according to
* https://discord.com/developers/docs/resources/webhook#execute-webhook
*/
/singleton/webhook/discord/CreateBody(list/data)
	if (discord_mentions)
		var/content = data["content"]
		if (content)
			data["content"] = "[discord_mentions]: [content]"
		else
			data["content"] = discord_mentions
	return json_encode(data)
