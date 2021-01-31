/decl/webhook/reg
	id = WEBHOOK_REG


/decl/webhook/reg/get_message(var/list/data)
	. = ..()

	.["content"] = "register_user [data["auth_key"]] [data["ckey"]]"
