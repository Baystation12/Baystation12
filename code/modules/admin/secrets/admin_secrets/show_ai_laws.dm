/datum/admin_secret_item/admin_secret/show_ai_laws
	name = "Show AI laws"

/datum/admin_secret_item/admin_secret/show_ai_laws/execute(var/mob/user)
	. = ..()
	if(.)
		user.client.holder.output_ai_laws()
