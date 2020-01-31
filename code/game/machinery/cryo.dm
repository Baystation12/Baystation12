#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 kg person.

/obj/machinery/atmospherics/unary/cryo_cell
	name = "cryo cell"
	icon = 'icons/obj/cryogenics.dmi' // map only
	icon_state = "pod_preview"
	density = TRUE
	anchored = TRUE
	interact_offline = TRUE
	layer = ABOVE_HUMAN_LAYER
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/on = FALSE
	idle_power_usage = 20
	active_power_usage = 200
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30

	var/temperature_archived
	var/mob/living/carbon/human/occupant = null
	var/obj/item/weapon/reagent_containers/glass/beaker = null

	var/current_heat_capacity = 50

	movement_handlers = list(/datum/movement_handler/move_relay)
	var/mob_breaking_out = FALSE

/obj/machinery/atmospherics/unary/cryo_cell/Initialize()
	. = ..()
	icon = 'icons/obj/cryogenics_split.dmi'
	update_icon()
	atmos_init()

/obj/machinery/atmospherics/unary/cryo_cell/Destroy()
	for(var/atom/movable/A in src)
		A.dropInto(loc)
	if(beaker)
		beaker.forceMove(get_step(loc, SOUTH)) //Beaker is carefully ejected from the wreckage of the cryotube
		beaker = null
	. = ..()

/obj/machinery/atmospherics/unary/cryo_cell/atmos_init()
	..()
	if(node) return
	var/node_connect = dir
	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

/obj/machinery/atmospherics/unary/cryo_cell/examine(mob/user)
	. = ..()
	if (user.Adjacent(src))
		if (beaker)
			to_chat(user, "It is loaded with a beaker.")
		if (occupant)
			occupant.examine(arglist(args))

/obj/machinery/atmospherics/unary/cryo_cell/Process()
	..()
	if(!node)
		return

	var/has_air_contents = FALSE
	if(air_contents) //Check this even if it's unpowered
		ADJUST_ATOM_TEMPERATURE(src, air_contents.temperature)
		if(beaker)
			QUEUE_TEMPERATURE_ATOMS(beaker)
		has_air_contents = TRUE

	if(!on)
		return

	if(occupant)
		if(occupant.stat != DEAD)
			process_occupant()

	if(has_air_contents)
		temperature_archived = air_contents.temperature
		heat_gas_contents()
		expel_gas()

	if(abs(temperature_archived-air_contents.temperature) > 1)
		network.update = TRUE

	return TRUE

/obj/machinery/atmospherics/unary/cryo_cell/relaymove(mob/user)
	if(occupant == user)
		if(user.stat == CONSCIOUS)
			go_out()
		else if(user.stat == UNCONSCIOUS && !mob_breaking_out)
			to_chat(user, SPAN_NOTICE("You begin to struggle out of \the [initial(src.name)], this will take two minutes."))
			mob_breaking_out = !!addtimer(CALLBACK(src, /obj/machinery/atmospherics/unary/cryo_cell/proc/go_out), 2 MINUTES, TIMER_UNIQUE)
		return MOVEMENT_HANDLED

/obj/machinery/atmospherics/unary/cryo_cell/interface_interact(user)
	ui_interact(user)
	return TRUE

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable (which is inherited by /obj and /mob)
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  * @param ui /datum/nanoui This parameter is passed by the nanoui process() proc when updating an open ui
  *
  * @return nothing
  */
/obj/machinery/atmospherics/unary/cryo_cell/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(user == occupant || user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? TRUE : FALSE

	if (occupant)
		var/cloneloss = "none"
		var/amount = occupant.getCloneLoss()
		if(amount > 50)
			cloneloss = "severe"
		else if(amount > 25)
			cloneloss = "significant"
		else if(amount > 10)
			cloneloss = "moderate"
		else if(amount)
			cloneloss = "minor"
		var/scan = medical_scan_results(occupant)
		scan += "<br><br>Genetic degradation: [cloneloss]"
		scan = replacetext(scan,"'scan_notice'","'white'")
		scan = replacetext(scan,"'scan_warning'","'average'")
		scan = replacetext(scan,"'scan_danger'","'bad'")
		scan += "<br>Cryostasis factor: [occupant.stasis_value]x"
		data["occupant"] = scan

	data["cellTemperature"] = round(air_contents.temperature)
	data["cellTemperatureStatus"] = "good"
	if(air_contents.temperature > T0C) // if greater than 273.15 kelvin (0 celsius)
		data["cellTemperatureStatus"] = "bad"
	else if(air_contents.temperature > 225)
		data["cellTemperatureStatus"] = "average"

	data["isBeakerLoaded"] = beaker ? TRUE : FALSE

	data["beakerLabel"] = null
	data["beakerVolume"] = 0
	if(beaker)
		data["beakerLabel"] = beaker.name
		data["beakerVolume"] = beaker.reagents.total_volume

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "cryo.tmpl", "Cryo Cell Control System", 520, 410)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/cryo_cell/OnTopic(user, href_list)
	if(user == occupant)
		return STATUS_CLOSE

	if(href_list["switchOn"])
		on = TRUE
		update_icon()
		return TOPIC_REFRESH

	if(href_list["switchOff"])
		on = FALSE
		update_icon()
		return TOPIC_REFRESH

	if(href_list["ejectBeaker"])
		if(beaker)
			beaker.forceMove(get_step(loc, SOUTH))
			beaker = null
		return TOPIC_REFRESH

	if(href_list["ejectOccupant"])
		if(!occupant || isslime(user) || ispAI(user))
			return TOPIC_HANDLED // don't update UIs attached to this object
		go_out()
		return TOPIC_REFRESH

/obj/machinery/atmospherics/unary/cryo_cell/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/atmospherics/unary/cryo_cell/attackby(var/obj/G, var/mob/user)
	if(component_attackby(G, user))
		return TRUE
	if(istype(G, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return
		if(!user.unEquip(G, src))
			return // Temperature will be adjusted on Entered()
		beaker =  G
		user.visible_message("[user] adds \a [G] to \the [src]!", "You add \a [G] to \the [src]!")
	else if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(!ismob(grab.affecting))
			return
		for(var/mob/living/carbon/slime/M in range(1,grab.affecting))
			if(M.Victim == grab.affecting)
				to_chat(user, "[grab.affecting.name] will not fit into the cryo because they have a slime latched onto their head.")
				return
		if(put_mob(grab.affecting))
			qdel(G)
	return

/obj/machinery/atmospherics/unary/cryo_cell/on_update_icon()
	overlays.Cut()
	icon_state = "pod[on]"
	var/image/I

	I = image(icon, "pod[on]_top")
	I.pixel_z = 32
	overlays += I

	if(occupant)
		var/image/pickle = image(occupant.icon, occupant.icon_state)
		pickle.overlays = occupant.overlays
		pickle.pixel_z = 18
		overlays += pickle

	I = image(icon, "lid[on]")
	overlays += I

	I = image(icon, "lid[on]_top")
	I.pixel_z = 32
	overlays += I

/obj/machinery/atmospherics/unary/cryo_cell/proc/process_occupant()
	if(air_contents.total_moles < 10)
		return
	if(occupant)
		if(occupant.stat == DEAD)
			return
		occupant.set_stat(UNCONSCIOUS)
		var/has_cryo_medicine = occupant.reagents.has_any_reagent(list(/datum/reagent/cryoxadone, /datum/reagent/clonexadone, /datum/reagent/nanitefluid)) >= REM
		if(beaker && !has_cryo_medicine)
			beaker.reagents.trans_to_mob(occupant, REM, CHEM_BLOOD)

/obj/machinery/atmospherics/unary/cryo_cell/proc/heat_gas_contents()
	if(air_contents.total_moles < 1)
		return
	var/air_heat_capacity = air_contents.heat_capacity()
	var/combined_heat_capacity = current_heat_capacity + air_heat_capacity
	if(combined_heat_capacity > 0)
		var/combined_energy = T20C*current_heat_capacity + air_heat_capacity*air_contents.temperature
		air_contents.temperature = combined_energy/combined_heat_capacity

/obj/machinery/atmospherics/unary/cryo_cell/proc/expel_gas()
	if(air_contents.total_moles < 1)
		return

/obj/machinery/atmospherics/unary/cryo_cell/proc/go_out()
	mob_breaking_out = FALSE
	if(!occupant)
		return
	//for(var/obj/O in src)
	//	O.loc = loc
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(get_step(loc, SOUTH))
	occupant.bodytemperature = max(occupant.bodytemperature, 261)
	occupant = null
	current_heat_capacity = initial(current_heat_capacity)
	update_use_power(POWER_USE_IDLE)
	update_icon()
	SetName(initial(name))
	return

/obj/machinery/atmospherics/unary/cryo_cell/proc/put_mob(mob/living/carbon/M)
	if (stat & (NOPOWER|BROKEN))
		to_chat(usr, SPAN_WARNING("The cryo cell is not functioning."))
		return FALSE
	if (!istype(M))
		to_chat(usr, SPAN_DANGER("The cryo cell cannot handle such a lifeform!"))
		return FALSE
	if (occupant)
		to_chat(usr, SPAN_DANGER("The cryo cell is already occupied!"))
		return FALSE
	if (M.abiotic())
		to_chat(usr, SPAN_WARNING("Subject may not have abiotic items on."))
		return FALSE
	if(!node)
		to_chat(usr, SPAN_WARNING("The cell is not correctly connected to its pipe network!"))
		return FALSE
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pulling()
	M.forceMove(src)
	M.ExtinguishMob()
	if(M.health > -100 && (M.health < 0 || M.sleeping))
		to_chat(M, SPAN_NOTICE("<b>You feel a cold liquid surround you. Your skin starts to freeze up.</b>"))
	occupant = M
	occupant.AddMovementHandler(/datum/movement_handler/move_relay) // Adds a new move_relay handler to the top of the list, so that it is checked before consciousness checks
	GLOB.moved_event.register(occupant, src, .proc/remove_handler)
	current_heat_capacity = HEAT_CAPACITY_HUMAN
	update_use_power(POWER_USE_ACTIVE)
	add_fingerprint(usr)
	update_icon()
	SetName("[name] ([occupant])")
	return TRUE

	//Like grab-putting, but for mouse-dropping.
/obj/machinery/atmospherics/unary/cryo_cell/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if (!istype(target))
		return
	if (target.buckled)
		to_chat(user, SPAN_WARNING("Unbuckle the subject before attempting to move them."))
		return
	user.visible_message(SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."), SPAN_NOTICE("You start placing \the [target] into \the [src]."))
	if(!do_after(user, 30, src))
		return
	put_mob(target)


/obj/machinery/atmospherics/unary/cryo_cell/verb/move_eject()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		return
	else
		if (usr.stat != CONSCIOUS)
			return
		go_out()
	add_fingerprint(usr)
	return

/obj/machinery/atmospherics/unary/cryo_cell/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return
	if (usr.stat != CONSCIOUS)
		return
	put_mob(usr)
	return

/obj/machinery/atmospherics/unary/cryo_cell/return_air()
	return air_contents

// Removes the movement handlers given to the occupant upon getting into the cryo-cell
/obj/machinery/atmospherics/unary/cryo_cell/proc/remove_handler()
	occupant.RemoveMovementHandler(/datum/movement_handler/move_relay) // Adds a new move_relay handler to the top of the list, so that it is checked before consciousness checks
	GLOB.moved_event.unregister(occupant, src)

//This proc literally only exists for cryo cells.
/atom/proc/return_air_for_internal_lifeform()
	return return_air()

/obj/machinery/atmospherics/unary/cryo_cell/return_air_for_internal_lifeform()
	//assume that the cryo cell has some kind of breath mask or something that
	//draws from the cryo tube's environment, instead of the cold internal air.
	if(loc)
		return loc.return_air()
	else
		return null

/datum/data/function/proc/reset()
	return

/datum/data/function/proc/r_input(href, href_list, mob/user)
	return

/datum/data/function/proc/display()
	return
