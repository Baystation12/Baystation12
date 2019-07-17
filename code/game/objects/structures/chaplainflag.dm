/obj/structure/chaplainflag
	name = "chaplain flag"
	desc = "A flag bearing the symbol of a religion, used to display the faith and services a chaplain is offering."
	icon = 'icons/obj/chaplainflags.dmi'
	icon_state = "blank"
	anchored = 1

/obj/structure/chaplainflag/examine(mob/user)
	. = ..(user, 2)
	if(.)
		if(icon_state == "blank")
			to_chat(user, "<br>It is currently blank.")
		if(icon_state == "chapel")
			to_chat(user, "<br>It bears a neutral symbol of the Chapel.")
		if(icon_state == "crucifix")
			to_chat(user, "<br>It bears a cross, the symbol of Christianity.")
		if(icon_state == "starofdavid")
			to_chat(user, "<br>It bears a Star of David, the symbol of Judaism.")
		if(icon_state == "moonandstar")
			to_chat(user, "<br>It bears a star & crescent, the symbol of Islam.")
		if(icon_state == "dharmachakra")
			to_chat(user, "<br>It bears a Dharma Chakra, the symbol of Buddhism.")
		if(icon_state == "aum")
			to_chat(user, "<br>It bears an Aum, the symbol of Hinduism.")
		if(icon_state == "khanda")
			to_chat(user, "<br>It bears a Khanda, the symbol of Sikhism.")
		if(icon_state == "ninepointedstar")
			to_chat(user, "<br>It bears a nine-pointed star, the symbol of the Baha'i Faith.")
		if(icon_state == "cult")
			to_chat(user, "<br>It bears an image of a terrifying apparation. Who would put this up...?")
	else ..()

/obj/structure/chaplainflag/attack_hand(mob/user)
	if(user.mind && user.mind.special_role == "Cultist")
		to_chat(user, SPAN_NOTICE("You corrupt \the [src]."))
		icon_state = "cult"
	else if(user.mind && istype(user.mind.assigned_job, /datum/job/chaplain) && !user.stat)
		var/flag_pick = input(user, "Pick your flag.", "Flag", null) in list("blank", "chapel", "crucifix", "starofdavid", "moonandstar", "dharmachakra", "aum", "khanda", "ninepointedstar")
		if(flag_pick && user.Adjacent(src))
			to_chat(user, SPAN_NOTICE("You set \the [src] to [flag_pick]!"))
			icon_state = flag_pick
