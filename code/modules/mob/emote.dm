// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null)

	if(stat || !use_me && usr == src)
		usr << "You are unable to emote."
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

		var/list/seeing_obj = list() //For objs that need to see emotes.  You can use see_emote(), which is based off of hear_talk()

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
				M.show_message(message)

		for(var/I in view(world.view, get_turf(usr))) //get_turf is needed to stop weirdness with x-ray.
			if(istype(I, /mob/))
				var/mob/M = I
				for(var/obj/O in M.contents)
					seeing_obj |= O
			else if(istype(I, /obj/))
				var/obj/O = I
				seeing_obj |= O

		// Type 1 (Visual) emotes are sent to anyone in view of the item
		if (m_type & 1)
			//for (var/mob/O in viewers(src, null))
			for (var/mob/O in viewers(get_turf(src), null)) //This may break people with x-ray being able to see emotes across walls,
															//but this saves many headaches down the road, involving mechs and pAIs.
															//x-ray is so rare these days anyways.

				if(O.status_flags & PASSEMOTES)

					for(var/obj/item/weapon/holder/H in O.contents)
						H.show_message(message, m_type)

					for(var/mob/living/M in O.contents)
						M.show_message(message, m_type)

				O.show_message(message, m_type)

			for(var/obj/O in seeing_obj)
				spawn(0)
					if(O) //It's possible that it could be deleted in the meantime.
						O.see_emote(src, message, 1)

		// Type 2 (Audible) emotes are sent to anyone in hear range
		// of the *LOCATION* -- this is important for AIs/pAIs to be heard
		else if (m_type & 2)
			for (var/mob/O in hearers(get_turf(src), null))

				if(O.status_flags & PASSEMOTES)

					for(var/obj/item/weapon/holder/H in O.contents)
						H.show_message(message, m_type)

					for(var/mob/living/M in O.contents)
						M.show_message(message, m_type)

				O.show_message(message, m_type)

			for(var/obj/O in seeing_obj)
				spawn(0)
					if(O) //It's possible that it could be deleted in the meantime.
						O.see_emote(src, message, 2)

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
