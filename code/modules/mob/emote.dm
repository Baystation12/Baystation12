// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null)
	if(stat || !use_me && usr == src)
		src << "You are unable to emote."
		return

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(m_type == 2 && muzzled) return

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

		for(var/mob/M in player_list)
			if (!M.client)
				continue //skip monkeys and leavers
			if (istype(M, /mob/new_player))
				continue
			if(findtext(message," snores.")) //Because we have so many sleeping people.
				break
			if(M.stat == 2 && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message, m_type)

		if (m_type & 1)
			var/list/see = get_mobs_or_objects_in_view(world.view,src) | viewers(get_turf(src), null)
			for(var/I in see)
				if(isobj(I))
					spawn(0)
						if(I) //It's possible that it could be deleted in the meantime.
							var/obj/O = I
							O.see_emote(src, message, 1)
				else if(ismob(I))
					var/mob/M = I
					M.show_message(message, 1)

		else if (m_type & 2)
			var/list/hear = get_mobs_or_objects_in_view(world.view,src)
			for(var/I in hear)
				if(isobj(I))
					spawn(0)
						if(I) //It's possible that it could be deleted in the meantime.
							var/obj/O = I
							O.see_emote(src, message, 2)
				else if(ismob(I))
					var/mob/M = I
					M.show_message(message, 2)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		src << "<span class='danger'>You cannot send deadchat emotes (muted).</span>"
		return

	if(!(client.prefs.toggles & CHAT_DEAD))
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
