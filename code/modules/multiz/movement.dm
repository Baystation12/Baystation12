/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		usr << "<span class='notice'>You move upwards.</span>"

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		usr << "<span class='notice'>You move down.</span>"

/mob/proc/zMove(direction)
	if(incapacitated())
		return 0
	if(!can_ztravel())
		src << "<span class='warning'>You lack means of travel in that direction.</span>"
		return
	var/turf/destination
	var/turf/start = get_turf(src)
	if(direction == UP)
		destination = GetAbove(src)
	else
		destination = GetBelow(src)

	if(!destination)
		src << "<span class='notice'>There is nothing of interest in this direction.</span>"
		return 0

	if(!destination.CanPass(src, start))
		src << "<span class='warning'>You bump against \the [destination].</span>"
		return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start))
			src << "<span class='warning'>\The [A] blocks you.</span>"
			return 0
	return Move(destination)

/mob/proc/can_ztravel()
	return 0

/mob/observer/can_ztravel()
	return 1

/mob/living/carbon/human/can_ztravel()
	if(istype(back,/obj/item/weapon/tank/jetpack))
		var/obj/item/weapon/tank/jetpack/jet = back
		if(jet.allow_thrust(0.01, src))
			return 1
		else
			src << "<span class='warning'>\The [jet] is disabled.</span>"
			return 0
	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1
	return 0