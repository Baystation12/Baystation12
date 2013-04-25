/*
Immovable rod random event.
The rod will spawn at some location outside the station, and travel in a straight line to the opposite side of the station
Everything solid in the way will be ex_act()'d
In my current plan for it, 'solid' will be defined as anything with density == 1

--NEOFite
*/

/datum/event_control/immovable_rod
	name = "Immovable Rod"
	typepath = /datum/event/immovable_rod
	max_occurrences = 5

/datum/event/immovable_rod
	announceWhen = 5

/datum/event/immovable_rod/announce()
	command_alert("What the fuck was that?!", "General Alert")

/datum/event/immovable_rod/start()
	var/startx = 0
	var/starty = 0
	var/endy = 0
	var/endx = 0
	var/startside = pick(cardinal)

	switch(startside)
		if(NORTH)
			starty = 187
			startx = rand(41, 199)
			endy = 38
			endx = rand(41, 199)
		if(EAST)
			starty = rand(38, 187)
			startx = 199
			endy = rand(38, 187)
			endx = 41
		if(SOUTH)
			starty = 38
			startx = rand(41, 199)
			endy = 187
			endx = rand(41, 199)
		else
			starty = rand(38, 187)
			startx = 41
			endy = rand(38, 187)
			endx = 199

	//rod time!
	new /obj/effect/immovablerod(locate(startx, starty, 1), locate(endx, endy, 1))


/obj/effect/immovablerod
	name = "Immovable Rod"
	desc = "What the fuck is that?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 100
	density = 1
	anchored = 1
	var/z_original = 0
	var/destination

	New(atom/start, atom/end)
		loc = start
		z_original = z
		destination = end
		if(end && end.z==z_original)
			walk_towards(src, destination, 1)

	Move()
		if(z != z_original || loc == destination)
			spawn(0) del(src)
		return ..()

	Bump(atom/clong)
		if(istype(clong, /turf/simulated/shuttle)) //Skip shuttles without actually deleting the rod
			return

		else if (istype(clong, /turf) && !istype(clong, /turf/unsimulated))
			if(clong.density)
				clong.ex_act(2)
				for (var/mob/O in hearers(src, null))
					O.show_message("CLANG", 2)

		else if (istype(clong, /obj))
			if(clong.density)
				clong.ex_act(2)
				for (var/mob/O in hearers(src, null))
					O.show_message("CLANG", 2)

		else if (istype(clong, /mob))
			if(clong.density || prob(10))
				clong.meteorhit(src)
		else
			del(src)

		if(clong && prob(25))
			src.loc = clong.loc
