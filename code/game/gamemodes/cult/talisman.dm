/obj/item/paper/talisman
	icon_state = "paper_talisman"
	var/imbue = null
	info = "<center><img src='talisman.png'></center><br/><br/>"
	language = LANGUAGE_CULT


/obj/item/paper/talisman/attack_self(mob/living/user)
	if(iscultist(user))
		to_chat(user, "Attack your target to use this talisman.")
	else
		to_chat(user, "You see strange symbols on the paper. Are they supposed to mean something?")


/obj/item/paper/talisman/attack(mob/living/M, mob/living/user)
	return
