/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = 3
	origin_tech = list(TECH_ENGINERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	var/searching = 0
	construction_cost = list(DEFAULT_WALL_MATERIAL=500,"glass"=500,"silver"=200,"gold"=200,"phoron"=100,"diamond"=10)
	construction_time = 75
	req_access = list(access_robotics)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.

/obj/item/device/mmi/digital/posibrain/New()
	..()
	brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	brainmob.real_name = src.brainmob.name

/obj/item/device/mmi/digital/posibrain/attack_self(var/mob/user)
	if(brainmob && !brainmob.key && !searching)
		//Start the process of searching for a new user.
		user << "<span class='notice'>You carefully locate the manual activation switch and start the positronic brain's boot process.</span>"
		icon_state = "posibrain-searching"
		searching = 1
		var/datum/ghosttrap/G = get_ghost_trap("positronic brain")
		G.request_player(brainmob, "A [src.name] has been booted by \the [user] in [get_area(user)]. ")
		spawn(600) reset_search()

/obj/item/device/mmi/digital/posibrain/attack_ghost(var/mob/dead/observer/user)
	var/datum/ghosttrap/G = get_ghost_trap("positronic brain")
	if(!G.assess_candidate(user))
		return
	var/response = alert(user, "Are you sure you want to play as a positronic brain?", "Positronic brain request", "Yes", "No")
	if(response == "Yes")
		if(G.transfer_personality(user, brainmob))
			var/turf/T = get_turf(src)
			T.visible_message("<span class='notice'>\The [src] chimes quietly.</span>")
			searching = 0
			name = "positronic brain ([brainmob.name])"
			icon_state = "posibrain-occupied"
	return

/obj/item/device/mmi/digital/posibrain/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	brainmob << "<span class='notify'>You feel slightly disoriented. That's normal when you're just a metal cube.</span>"
	icon_state = "posibrain-occupied"
	return

/obj/item/device/mmi/digital/posibrain/proc/reset_search()
	if(!searching || (src.brainmob && src.brainmob.key))
		return
	searching = 0
/obj/item/device/mmi/digital/posibrain/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a positronic brain now.")
	src.searching = 0
	src.brainmob.mind = candidate.mind
	src.brainmob.ckey = candidate.ckey
	src.brainmob.mind.reset()
	src.name = "positronic brain ([src.brainmob.name])"
	src.brainmob << "<b>You are a positronic brain, brought into existence on [station_name()].</b>"
	src.brainmob << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	src.brainmob << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	src.brainmob << "<b>Use say :b to speak to other artificial intelligences.</b>"
	src.brainmob.mind.assigned_role = "Positronic Brain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain chimes quietly.")
	icon_state = "posibrain-occupied"

/obj/item/device/mmi/digital/posibrain/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.

	if(src.brainmob && src.brainmob.key) return

	src.searching = 0
	icon_state = "posibrain"
	var/turf/T = get_turf(src)
	T.visible_message("<span class='notice'>\The [src] brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?</span>")

/obj/item/device/mmi/digital/posibrain/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*\</span>nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "</span><span class='info'>*---------*</span>"
	user << msg
	return

/obj/item/device/mmi/digital/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()

