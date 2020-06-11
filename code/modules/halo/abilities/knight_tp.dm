
/obj/effect/landmark/knight_evac_to
	name = "Knight Evac Point"
	desc = "Knights who emergency-evac will arrive here."
	invisibility = 61

/mob/living/proc/tele_evac()
	set category = "Abilities"
	set name = "Activate Teleportation Evac"
	set desc = "Allows you to teleport out of the system (functionally death) or to a marker, if it is placed."

	var/obj/tp_to = locate(/obj/effect/landmark/knight_evac_to)

	visible_message("<span class = 'danger'>[src] starts preparing for long range slipspace translocation...</span>")
	if(!do_after(src,5 SECONDS))
		return
	do_tele_evac(tp_to)

/mob/living/proc/do_tele_evac(var/obj/tp_to)
	var/list/tp_target = list()
	for(var/mob/living/m in range(1,loc))
		if(m == src)
			continue
		tp_target += m
		new /obj/effect/knightroll_tp(m.loc)

	tp_target += src

	if(tp_to)
		new /obj/effect/knightroll_tp(tp_to.loc)

	for(var/mob in tp_target)
		var/mob/m = mob
		to_chat(m,"<span class = 'warning'>You have been forcibly translocated to Promethean-controlled space</span>")
		if(tp_to)
			m.forceMove(tp_to.loc)
		else
			qdel(m)
