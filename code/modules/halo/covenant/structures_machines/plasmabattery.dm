
/obj/structure/plasma_battery
	name = "plasma battery"
	desc = "A portable power cell for plasma powered machinery and devices used by the Covenant."
	icon = 'code/modules/halo/covenant/structures_machines/plasma_battery.dmi'
	icon_state = "full"
	density = 1
	var/last_use_time = 0
	var/draining = 0
	var/charge = 100

/obj/structure/plasma_battery/proc/drain_plasma(var/amount)
	charge -= amount
	last_use_time = world.time
	if(charge > 0)
		if(!draining)
			icon_state = "in_use"
			GLOB.processing_objects |= src
			draining = 1
	else
		icon_state = "drained"
		. = 0

/obj/structure/plasma_battery/process()
	if(world.time > last_use_time + 30)
		if(charge > 0)
			icon_state = "full"
		draining = 0
		GLOB.processing_objects -= src

/obj/structure/plasma_battery/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()

	to_chat(user, "<span class='info'>There is [charge]% charge left.</span>")
