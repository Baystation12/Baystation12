/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon = 'icons/obj/tools/megaphone.dmi'
	icon_state = "megaphone"
	item_state = "radio"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	var/last_broadcasted = 0

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (muted)."))
			return
	if (user.silent)
		return
	if (last_broadcasted && last_broadcasted + 2 SECONDS > world.time)
		to_chat(user, SPAN_WARNING("\The [src] needs to recharge!"))
		return
	var/datum/language/current_spoken_language = user.get_audible_default_language()
	if (!current_spoken_language)
		to_chat(user, SPAN_WARNING("You do not have an audible language selected as your default!"))
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
	if (src.loc == user && usr.stat == 0)
		last_broadcasted = world.time
		var/viewers = viewers(user)
		var/clients = list()
		for (var/mob/listener in viewers)
			listener.hear_say(message, "broadcasts", current_spoken_language, "", FALSE, user, null, null, TRUE)
			if (listener.client)
				clients += listener.client
		if (length(clients))
			invoke_async(user, TYPE_PROC_REF(/atom/movable, animate_chat), message, current_spoken_language, RUNECHAT_LARGE, clients, "radio")
		log_say("[key_name(user.name)] : ([user.name]) used a megaphone to broadcast: [message]")
