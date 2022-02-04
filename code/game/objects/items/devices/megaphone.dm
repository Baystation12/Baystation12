/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon = 'icons/obj/megaphone.dmi'
	icon_state = "megaphone"
	item_state = "radio"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	var/spamcheck = 0
	var/emagged = FALSE
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return
	if(user.silent)
		return
	if(spamcheck)
		to_chat(user, "<span class='warning'>\The [src] needs to recharge!</span>")
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	var/datum/language/lang

	if(!message)
		return

	lang = user.parse_language(message)
	if(lang)
		message = copytext_char(message, 2 + length_char(lang.key))
	else
		lang = user.get_default_language()

	if(lang.flags & (NONVERBAL | SIGNLANG))
		to_chat(user, SPAN_WARNING("You can't use sign language!"))
		return

	message = trim_left(message)
	message = capitalize(message)
	var/list/rec = list()
	if ((src.loc == user && usr.stat == 0))
		if(emagged)
			if(insults)
				var/picked = pick(insultmsg)
				for(var/mob/O in (viewers(user)))
					O.hear_say(picked, "broadcasts", lang, null, 0, user, null, null, 6)
					if(O.client)
						rec |= O.client

				INVOKE_ASYNC(user, /atom/movable/proc/animate_chat, picked, lang, 0, rec, 5 SECONDS, 1)
				insults--
			else
				to_chat(user, "<span class='warning'>*BZZZZzzzzzt*</span>")
		else
			for(var/mob/O in (viewers(user)))
				O.hear_say(message, "broadcasts", lang, null, 0, user, null, null, 6)
				if(O.client)
					rec |= O.client

			INVOKE_ASYNC(user, /atom/movable/proc/animate_chat, message, lang, 0, rec, 5 SECONDS, 1)

		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

/obj/item/device/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='warning'>You overload \the [src]'s voice synthesizer.</span>")
		emagged = TRUE
		insults = rand(1, 3)//to prevent dickflooding
		return 1
