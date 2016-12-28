/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(usr, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(usr, "<span class='notice'>You move down.</span>")

/mob/proc/zMove(direction)
	if(eyeobj)
		return eyeobj.zMove(direction)
	if(!can_ztravel())
		to_chat(usr, "<span class='warning'>You lack means of travel in that direction.</span>")
		return

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)

	if(!destination)
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return 0

	var/turf/start = get_turf(src)
	if(!destination.CanPass(src, start))
		to_chat(usr, "<span class='warning'>You bump against \the [destination].</span>")
		return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start))
			to_chat(usr, "<span class='warning'>\The [A] blocks you.</span>")
			return 0
	Move(destination)
	return 1

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/proc/can_ztravel()
	return 0

/mob/observer/can_ztravel()
	return 1

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return 0

	if(istype(back,/obj/item/weapon/tank/jetpack))
		var/obj/item/weapon/tank/jetpack/jet = back
		if(jet.allow_thrust(0.01, src))
			return 1
		else
			to_chat(usr, "<span class='warning'>\The [jet] is disabled.</span>")
			return 0
	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1
	return 0

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return 0

	if(Allow_Spacemove()) //Checks for active jetpack
		return 1

		for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
			if(T.density)
				return 1
	return 0
