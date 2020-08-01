
/obj/machinery/power/shuttle_charger
	name = "shuttle APC transformer"
	desc = "An automated recharging device for a shuttle to recharge it's onboard APC."
	icon = 'code/modules/halo/overmap/fusion_thruster.dmi'
	icon_state = "power"
	anchored = 0
	density = 1
	var/datum/shuttle/my_shuttle
	var/list/connected_terminals = list()

/obj/machinery/power/shuttle_charger/Initialize()
	. = ..()
	if(powernet)
		overlays |= "bolts"
		anchored = 1

/obj/machinery/power/shuttle_charger/attack_hand(var/mob/user)
	if(!anchored)
		to_chat(user,"\icon[src] <span class='warning'>[src] must be bolted to the ground first!</span>")
		return

	if(!powernet)
		to_chat(user,"\icon[src] <span class='warning'>[src] is not connected to a power network!</span>")
		return

	if(do_after(user, 1 SECONDS))
		shuttle_connect()
		if(my_shuttle)
			if(connected_terminals.len)
				to_chat(user,"\icon[src] <span class='info'>Connected and charging to [my_shuttle].</span>")
			else
				to_chat(user,"\icon[src] <span class='warning'>Unable to detect any charging terminals on [my_shuttle].</span>")
		else
			to_chat(user,"\icon[src] <span class='info'>No shuttle found.</span>")

/obj/machinery/power/shuttle_charger/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = !anchored
		if(anchored)
			overlays |= "bolts"
			connect_to_network()
		else
			overlays -= "bolts"
			disconnect_from_network()
			icon_state = "power"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='info'>You [anchored ? "" : "un"]secure the bolts holding [src] in place.</span>")

/obj/machinery/power/shuttle_charger/proc/shuttle_connect()

	//reset any existing connection
	shuttle_disconnect()

	//cant charge shuttles if we dont have a powernet
	if(!powernet)
		return

	//search adjacent turfs
	var/area/my_area = get_area(src)
	for(var/turf/T in orange(1))
		//is this the same area as us?
		var/area/cur_area = get_area(T)
		if(cur_area == my_area)
			continue

		//check if this is a valid shuttle
		for(var/shuttle_name in shuttle_controller.shuttles)
			var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_name]
			if(cur_area in S.shuttle_area)
				//found it
				my_shuttle = S
				anchored = 1
				icon_state = "power_lacking"

				//tell the shuttle about us
				if(my_shuttle.connected_charger)
					//only one charger can be connected at a time
					my_shuttle.connected_charger.shuttle_disconnect()
				my_shuttle.connected_charger = src

				//connect any charging terminals on board
				for(var/area/check_area in my_shuttle.shuttle_area)
					for(var/obj/machinery/power/terminal/terminal in check_area)
						connected_terminals.Add(terminal)
						powernet.add_machine(terminal)
						icon_state = "power_charging"
				return

/obj/machinery/power/shuttle_charger/proc/shuttle_disconnect()
	if(my_shuttle)
		my_shuttle.connected_charger = null
	my_shuttle = null
	for(var/obj/machinery/power/terminal/terminal in connected_terminals)
		terminal.disconnect_from_network()
	connected_terminals = list()
	icon_state = "power"

/obj/machinery/power/shuttle_charger/examine(var/mob/user)
	. = ..()

	switch(icon_state)
		if("power_charging")
			to_chat(user, "It is connected and charging a shuttle.")
		if("power_lacking")
			to_chat(user, "It is connected but not charging a shuttle.")
