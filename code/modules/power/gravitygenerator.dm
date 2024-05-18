// It.. uses a lot of power.  Everything under power is engineering stuff, at least.

/obj/machinery/computer/gravity_control_computer
	name = "gravity generator control console"
	desc = "A computer to control a local gravity generator.  Qualified personnel only."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "airtunnel0e"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/gravity_generator/gravity_generator

/obj/machinery/gravity_generator
	name = "gravitational generator"
	desc = "A device which produces a gravaton field when set up."
	icon = 'icons/obj/machines/power/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = TRUE
	density = TRUE
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
		gravity_generator = locate(/obj/machinery/gravity_generator, get_step(src, dir))
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
	//dat += SPAN_SIZE("-1", "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a>")
	if(gravity_generator)
		if(gravity_generator.on)
			dat += "[SPAN_COLOR("green", "<br><tt>Gravity Status: ON</tt>")]<br>"
		else
			dat += "[SPAN_COLOR("red", "<br><tt>Gravity Status: OFF</tt>")]<br>"

		dat += "<br><tt>Currently Supplying Gravitons To:</tt><br>"

		for(var/area/A in gravity_generator.localareas)
			if(A.has_gravity && gravity_generator.on)
				dat += "<tt>[SPAN_COLOR("green", A)]</tt><br>"

			else if (A.has_gravity)
				dat += "<tt>[SPAN_COLOR("yellow", A)]</tt><br>"

			else
				dat += "<tt>[SPAN_COLOR("red", A)]</tt><br>"

		dat += "<br><tt>Maintainence Functions:</tt><br>"
		if(gravity_generator.on)
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'>[SPAN_COLOR("red", " TURN GRAVITY GENERATOR OFF. ")]</a>"
		else
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'>[SPAN_COLOR("green", " TURN GRAVITY GENERATOR ON. ")]</a>"

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
				for(var/obj/machinery/gravity_generator/G as anything in SSmachines.get_machinery_of_type(/obj/machinery/gravity_generator))
					if((A in G.localareas) && (G.on))
						A.gravitychange(0)
						break

		else
			for(var/area/A in gravity_generator.localareas)
				gravity_generator.on = 1
				A.gravitychange(1)

	src.updateUsrDialog()
