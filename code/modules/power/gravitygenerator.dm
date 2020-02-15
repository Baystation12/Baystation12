// It.. uses a lot of power.  Everything under power is engineering stuff, at least.

/obj/machinery/computer/gravity_control_computer
	name = "Gravity Generator Control"
	desc = "A computer to control a local gravity generator.  Qualified personnel only."
	icon = 'icons/obj/computer.dmi'
	icon_state = "airtunnel0e"
	anchored = 1
	density = 1
	var/obj/machinery/gravity_generator/gravity_generator

/obj/machinery/gravity_generator/
	name = "Gravitational Generator"
	desc = "A device which produces a gravaton field when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 1
	density = 1
	idle_power_usage = 200
	active_power_usage = 1000
	var/on = 1
	var/list/localareas = list()
	var/effectiverange = 25

	// Borrows code from cloning computer
/obj/machinery/computer/gravity_control_computer/Initialize()
	. = ..()
	updatemodules()

/obj/machinery/gravity_generator/Initialize()
	. = ..()
	locatelocalareas()

/obj/machinery/computer/gravity_control_computer/proc/updatemodules()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		gravity_generator = locate(/obj/machinery/gravity_generator/, get_step(src, dir))
		if (gravity_generator)
			return

/obj/machinery/gravity_generator/proc/locatelocalareas()
	for(var/area/A in range(src,effectiverange))
		if(istype(A,/area/space))
			continue // No (de)gravitizing space.
		localareas |= A

/obj/machinery/computer/gravity_control_computer/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/gravity_control_computer/interact(mob/user)
	user.set_machine(src)

	updatemodules()

	var/dat = "<h3>Generator Control System</h3>"
	//dat += "<font size=-1><a href='byond://?src=\ref[src];refresh=1'>Refresh</a></font>"
	if(gravity_generator)
		if(gravity_generator.on)
			dat += "<font color=green><br><tt>Gravity Status: ON</tt></font><br>"
		else
			dat += "<font color=red><br><tt>Gravity Status: OFF</tt></font><br>"

		dat += "<br><tt>Currently Supplying Gravitons To:</tt><br>"

		for(var/area/A in gravity_generator.localareas)
			if(A.has_gravity && gravity_generator.on)
				dat += "<tt><font color=green>[A]</tt></font><br>"

			else if (A.has_gravity)
				dat += "<tt><font color=yellow>[A]</tt></font><br>"

			else
				dat += "<tt><font color=red>[A]</tt></font><br>"

		dat += "<br><tt>Maintainence Functions:</tt><br>"
		if(gravity_generator.on)
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'><font color=red> TURN GRAVITY GENERATOR OFF. </font></a>"
		else
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'><font color=green> TURN GRAVITY GENERATOR ON. </font></a>"

	else
		dat += "No local gravity generator detected!"

	show_browser(user, dat, "window=gravgen")
	onclose(user, "gravgen")


/obj/machinery/computer/gravity_control_computer/Topic(href, href_list)
	set background = 1
	if((. = ..()))
		close_browser(usr, "window=air_alarm")
		return

	if(href_list["gentoggle"])
		if(gravity_generator.on)
			gravity_generator.on = 0

			for(var/area/A in gravity_generator.localareas)
				var/obj/machinery/gravity_generator/G
				for(G in SSmachines.machinery)
					if((A in G.localareas) && (G.on))
						break
				if(!G)
					A.gravitychange(0)
		else
			for(var/area/A in gravity_generator.localareas)
				gravity_generator.on = 1
				A.gravitychange(1)

	src.updateUsrDialog()
