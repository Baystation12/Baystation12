/obj/machinery/compressor
	name = "compressor"
	desc = "The compressor stage of a gas turbine generator."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "compressor"
	anchored = TRUE
	density = TRUE
	machine_name = "turbine control console"
	machine_desc = "Used to monitor, operate, and configure a connected gas turbine."
	var/obj/machinery/power/turbine/turbine
	var/datum/gas_mixture/gas_contained
	var/turf/simulated/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/comp_id = 0

/obj/machinery/power/turbine
	name = "gas turbine generator"
	desc = "A gas turbine used for backup power generation."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "turbine"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/compressor/compressor
	var/turf/simulated/outturf
	var/lastgen

/obj/machinery/computer/turbine_computer
	name = "Gas turbine control computer"
	desc = "A computer to remotely control a gas turbine."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "tech_key"
	icon_screen = "turbinecomp"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/compressor/compressor
	var/list/obj/machinery/door/blast/doors
	var/door_status = 0

// the inlet stage of the gas turbine electricity generator

/obj/machinery/compressor/Initialize()
	. = ..()
	gas_contained = new
	inturf = get_step(src, dir)
	turbine = locate() in get_step(src, get_dir(inturf, src))
	if(!turbine)
		set_broken(TRUE)
	else
		turbine.compressor = src

/obj/machinery/compressor/Destroy()
	if(turbine)
		turbine.compressor = null
		turbine.set_broken(TRUE)
		turbine = null
	QDEL_NULL(gas_contained)
	return ..()

#define COMPFRICTION 5e5
#define COMPSTARTERLOAD 2800

/obj/machinery/compressor/Process()
	if(!starter)
		return
	overlays.Cut()
	if(stat & BROKEN)
		return
	rpm = 0.9* rpm + 0.1 * rpmtarget
	var/datum/gas_mixture/environment = inturf.return_air()
	var/transfer_moles = environment.total_moles / 10
	//var/transfer_moles = rpm/10000*capacity
	var/datum/gas_mixture/removed = inturf.remove_air(transfer_moles)
	gas_contained.merge(removed)

	rpm = max(0, rpm - (rpm*rpm)/COMPFRICTION)


	if(starter && !(stat & NOPOWER))
		use_power_oneoff(2800)
		if(rpm<1000)
			rpmtarget = 1000
	else
		if(rpm<1000)
			rpmtarget = 0



	if(rpm>50000)
		overlays += image('icons/obj/pipes.dmi', "comp-o4", FLY_LAYER)
	else if(rpm>10000)
		overlays += image('icons/obj/pipes.dmi', "comp-o3", FLY_LAYER)
	else if(rpm>2000)
		overlays += image('icons/obj/pipes.dmi', "comp-o2", FLY_LAYER)
	else if(rpm>500)
		overlays += image('icons/obj/pipes.dmi', "comp-o1", FLY_LAYER)
	 //TODO: DEFERRED

/obj/machinery/power/turbine/Initialize()
	..()
	outturf = get_step(src, dir)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/turbine/LateInitialize()
	..()
	if(!compressor) // It should have found us and subscribed.
		set_broken(TRUE)

/obj/machinery/power/turbine/Destroy()
	if(compressor)
		compressor.turbine = null
		compressor.set_broken(TRUE)
		compressor = null
	return ..()

#define TURBPRES 9000000
#define TURBGENQ 20000
#define TURBGENG 0.8

/obj/machinery/power/turbine/Process()
	if(!compressor.starter)
		return
	overlays.Cut()
	if(stat & BROKEN)
		return
	lastgen = ((compressor.rpm / TURBGENQ)**TURBGENG) *TURBGENQ

	add_avail(lastgen)
	var/newrpm = ((compressor.gas_contained.temperature) * compressor.gas_contained.total_moles)/4
	newrpm = max(0, newrpm)

	if(!compressor.starter || newrpm > 1000)
		compressor.rpmtarget = newrpm

	if(compressor.gas_contained.total_moles>0)
		var/oamount = min(compressor.gas_contained.total_moles, (compressor.rpm+100)/35000*compressor.capacity)
		var/datum/gas_mixture/removed = compressor.gas_contained.remove(oamount)
		outturf.assume_air(removed)

	if(lastgen > 100)
		overlays += image('icons/obj/pipes.dmi', "turb-o", FLY_LAYER)


	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)

/obj/machinery/power/turbine/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (NOPOWER|BROKEN)) && (!istype(user, /mob/living/silicon/ai)) )
		user.machine = null
		close_browser(user, "window=turbine")
		return

	user.machine = src

	var/t = "<TT><B>Gas Turbine Generator</B><HR><PRE>"

	t += "Generated power : [round(lastgen)] W<BR><BR>"

	t += "Turbine: [round(compressor.rpm)] RPM<BR>"

	t += "Starter: [ compressor.starter ? "<A href='?src=\ref[src];str=1'>Off</A> <B>On</B>" : "<B>Off</B> <A href='?src=\ref[src];str=1'>On</A>"]"

	t += "</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	show_browser(user, t, "window=turbine")
	onclose(user, "turbine")

	return

/obj/machinery/power/turbine/CanUseTopic(var/mob/user, href_list)
	if(!user.IsAdvancedToolUser())
		to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
		return min(..(), STATUS_UPDATE)
	return ..()

/obj/machinery/power/turbine/OnTopic(user, href_list)
	if(href_list["close"])
		close_browser(usr, "window=turbine")
		return TOPIC_HANDLED

	if(href_list["str"])
		compressor.starter = !compressor.starter
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/obj/machinery/computer/turbine_computer/Initialize()
	. = ..()
	for(var/obj/machinery/compressor/C in SSmachines.machinery)
		if(id_tag == C.comp_id)
			compressor = C
	doors = new /list()
	for(var/obj/machinery/door/blast/P in SSmachines.machinery)
		if(P.id_tag == id_tag)
			doors += P

/obj/machinery/computer/turbine_computer/Destroy()
	doors.Cut()
	compressor = null
	return ..()

/obj/machinery/computer/turbine_computer/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/turbine_computer/interact(var/mob/user)
	user.machine = src
	var/dat
	if(src.compressor)
		dat += {"<BR><B>Gas turbine remote control system</B><HR>
		\nTurbine status: [ src.compressor.starter ? "<A href='?src=\ref[src];str=1'>Off</A> <B>On</B>" : "<B>Off</B> <A href='?src=\ref[src];str=1'>On</A>"]
		\n<BR>
		\nTurbine speed: [src.compressor.rpm]rpm<BR>
		\nPower currently being generated: [src.compressor.turbine.lastgen]W<BR>
		\nInternal gas temperature: [src.compressor.gas_contained.temperature]K<BR>
		\nVent doors: [ src.door_status ? "<A href='?src=\ref[src];doors=1'>Closed</A> <B>Open</B>" : "<B>Closed</B> <A href='?src=\ref[src];doors=1'>Open</A>"]
		\n</PRE><HR><A href='?src=\ref[src];view=1'>View</A>
		\n</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>
		\n<BR>
		\n"}
	else
		dat += "<span class='danger'>No compatible attached compressor found.</span>"

	show_browser(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return



/obj/machinery/computer/turbine_computer/OnTopic(user, href_list)
	if( href_list["view"] )
		usr.client.eye = src.compressor
		. = TOPIC_HANDLED
	else if( href_list["str"] )
		src.compressor.starter = !src.compressor.starter
		. = TOPIC_REFRESH
	else if (href_list["doors"])
		for(var/obj/machinery/door/blast/D in src.doors)
			if (door_status == 0)
				spawn( 0 )
					D.open()
					door_status = 1
			else
				spawn( 0 )
					D.close()
					door_status = 0
		. = TOPIC_REFRESH
	else if( href_list["close"] )
		close_browser(user, "window=computer")
		return TOPIC_HANDLED

	if(. == TOPIC_REFRESH)
		interact(user)
