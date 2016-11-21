// All mobs should have custom emote, really..
//m_type == VISIBLE_MESSAGE --> visual.
//m_type == AUDIBLE_MESSAGE --> audible
/mob/proc/custom_emote(var/m_type=VISIBLE_MESSAGE,var/message = null)
	if(usr && stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
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
	sanitize_and_communicate(/decl/communication_channel/dsay, client, message, /decl/dsay_communication/emote)
