// All mobs should have custom emote, really..
//m_type == VISIBLE_MESSAGE --> visual.
//m_type == AUDIBLE_MESSAGE --> audible
/mob/proc/custom_emote(var/m_type=VISIBLE_MESSAGE,var/message = null)
	if(usr && stat || !use_me && usr == src)
		src << "You are unable to emote."
		return

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(m_type == AUDIBLE_MESSAGE && muzzled) return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input = message
	if(input)
		message = "<B>[src]</B> [input]"
	else
		return


	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		switch(m_type)
			if(VISIBLE_MESSAGE)
				visible_message(message, checkghosts = /datum/client_preference/ghost_sight)
			if(AUDIBLE_MESSAGE)
				audible_message(message, checkghosts = /datum/client_preference/ghost_sight)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		src << "<span class='danger'>You cannot send deadchat emotes (muted).</span>"
		return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		src << "<span class='danger'>You have deadchat muted.</span>"
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			src << "<span class='danger'>Deadchat is globally muted.</span>"
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input = message

	if(input)
		log_emote("Ghost/[src.key] : [input]")
		say_dead_direct(input, src)
