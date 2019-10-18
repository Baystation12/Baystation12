
/obj/structure/deity/pylon
	name = "pylon"
	desc = "A crystal platform used to communicate with the deity."
	build_cost = 400
	icon = 'icons/obj/pylon.dmi'
	icon_state = "pylon"
	var/list/intuned = list()

/obj/structure/deity/pylon/attack_deity(var/mob/living/deity/D)
	if(D.pylon == src)
		D.leave_pylon()
	else
		D.possess_pylon(src)

/obj/structure/deity/pylon/Destroy()
	if(linked_god && linked_god.pylon == src)
		linked_god.leave_pylon()
	return ..()

/obj/structure/deity/pylon/attack_hand(var/mob/living/L)
	if(!linked_god)
		return
	if(L in intuned)
		remove_intuned(L)
	else
		add_intuned(L)

/obj/structure/deity/pylon/proc/add_intuned(var/mob/living/L)
	if(L in intuned)
		return
	to_chat(L, "<span class='notice'>You place your hands on \the [src], feeling yourself intune to its vibrations.</span>")
	intuned += L
	GLOB.destroyed_event.register(L,src,/obj/structure/deity/pylon/proc/remove_intuned)

/obj/structure/deity/pylon/proc/remove_intuned(var/mob/living/L)
	if(!(L in intuned))
		return
	to_chat(L, "<span class='warning'>You no longer feel intuned to \the [src].</span>")
	intuned -= L
	GLOB.destroyed_event.unregister(L, src)

/obj/structure/deity/pylon/OnTopic(var/mob/living/carbon/human/user, var/href_list)
	if(href_list["vision_jump"])
		if(istype(user))
			to_chat(user,"<span class='warning'>You feel your body lurch uncomfortably as your consciousness jumps to \the [src]</span>")
			if(prob(5))
				user.vomit()
		else
			to_chat(user, "<span class='notice'>You jump to \the [src]</span>")
		if(user.eyeobj)
			user.eyeobj.setLoc(locate(href_list["vision_jump"]))
		else
			CRASH("[user] does not have an eyeobj")
		. = TOPIC_REFRESH
	. = ..()

/obj/structure/deity/pylon/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(!linked_god)
		return
	if(linked_god.pylon != src)
		if(!(M in intuned))
			return
		for(var/obj/structure/deity/pylon/P in linked_god.structures)
			if(P == src || linked_god.pylon == P)
				continue
			P.audible_message("<b>\The [P]</b> resonates, \"[text]\"")
	to_chat(linked_god, "\icon[src] <span class='game say'><span class='name'>[M]</span> (<A href='?src=\ref[linked_god];jump=\ref[src];'>P</A>) [verb], [linked_god.pylon == src ? "<b>" : ""]<span class='message'><span class='body'>\"[text]\"</span></span>[linked_god.pylon == src ? "</b>" : ""]</span>")
	if(linked_god.minions.len)
		for(var/minion in linked_god.minions)
			var/datum/mind/mind = minion
			if(mind.current && mind.current.eyeobj) //If it is currently having a vision of some sort
				to_chat(mind.current,"\icon[src] <span class='game say'><span class='name'>[M]</span> (<A href='?src=\ref[src];vision_jump=\ref[src];'>J</A>) [verb], <span class='message'<span class='body'>\"[text]\"</span></span>")