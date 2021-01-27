/decl/webhook/ooc
	id = WEBHOOK_OOC


/decl/webhook/ooc/get_message(var/list/data)
	. = ..()
	var/cur_time = world.timeofday

	.["content"] = "`\[[time2text(cur_time, "hh:mm:ss")]\]` **OOC: [data["key"]]**: [data["message"]]"
