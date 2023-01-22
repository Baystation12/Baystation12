/decl/webhook/xeno_msg
	id = WEBHOOK_XENO_WHITELIST

/decl/webhook/xeno_msg/get_message(var/list/data)
	. = ..()

	if(!length(data))
		.["content"] = "Тут должно быть сообщение о вайтлисте, но кто то вызвал вебхук вручную."
		return

	if(!data["grant"] && !data["revoke"])
		return
	if(!data["ckey"])		data["ckey"] = "ДАННЫЕ УДАЛЕНЫ"
	if(!data["type"])		data["type"] = "ДАННЫЕ УДАЛЕНЫ"

	var/list/desc = list()
	desc["title"] = "Ксеномодератор - [data["ckey"]]"
	desc["description"] = "Изменения внесены в [data["type"]]"
	desc["color"] = COLOR_WEBHOOK_XENO
	desc["author"] = list(
		"name" = "Изменение вайтлиста на расы",
		"icon_url" = "https://cdn.discordapp.com/emojis/244791612268347392.png")	// :inf: emoji

	var/list/grant = data["grant"]
	var/list/revoke = data["revoke"]
	var/icon = "https://cdn.discordapp.com/emojis/680793066415980576.png"			// :SeemsRichKot: emoji
	if(!grant || (revoke && (revoke.len >= grant.len)))
		icon = "https://cdn.discordapp.com/emojis/601028456675016706.png"			// :resomisad: emoji
	desc["thumbnail"] = list("url" = icon)
/*
	var/list/unite = list()

	for(var/ckey in grant)
		var/list/temp = list()
		var/list/check = grant[ckey]
		for(var/race in check)
			temp += "++[race]"
		unite[ckey] += list(temp)
	for(var/ckey in revoke)
		var/list/temp = list()
		var/list/check = revoke[ckey]
		for(var/race in check)
			temp += "--[race]"
		unite[ckey] += list(temp)
*/
	var/list/A = list()
	var/list/B = list()
	for(var/ckey in grant)
		var/list/check = grant[ckey]
		for(var/race in check)
			B += "+ [race]"
		A[ckey] = B.Copy()
		B.Cut()
	grant = A.Copy()
	A.Cut()
	B.Cut()
	for(var/ckey in revoke)
		var/list/check = revoke[ckey]
		for(var/race in check)
			B += "- [race]"
		A[ckey] = B.Copy()
		B.Cut()
	revoke = A.Copy()

	var/list/unite = list()
	for(var/ckey in grant)
		unite[ckey] = grant[ckey]
	for(var/ckey in revoke)
		unite[ckey] += revoke[ckey]

	if(!unite || !unite.len)
		.["content"] = "Сюда пришло изменение вайтлиста, но мы потеряли список."
		return
	var/list/fields = list()
	unite = sortAssoc(unite)		//sorting by ckey
	for(var/ckey2 in unite)
		var/list/check = unite[ckey2]
		check = sortList(check)	//sorting by race
		var/list/text = list("diff")
		for(var/race in check)
			text += race
		fields[++fields.len] = list(
			"name" = ckey2,
			"value" = "```[jointext(text, "\n")]```"
		)
	if(fields && fields.len)
		desc["fields"] = fields
	.["embeds"] = list(desc)
