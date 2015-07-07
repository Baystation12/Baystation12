/turf/simulated/floor/mech_bay_recharge_floor
	name = "Mech Bay Recharge Station"
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	var/obj/machinery/mech_bay_recharge_port/recharge_port
	var/obj/machinery/computer/mech_bay_power_console/recharge_console
	var/obj/mecha/recharging_mecha = null

/turf/simulated/floor/mech_bay_recharge_floor/Entered(var/obj/mecha/mecha)
	. = ..()
	if(istype(mecha))
		mecha.occupant_message("<b>Initializing power control devices.</b>")
		init_devices()
		if(recharge_console && recharge_port)
			recharging_mecha = mecha
			recharge_console.mecha_in(mecha)
			return
		else if(!recharge_console)
			mecha.occupant_message("<font color='red'>Control console not found. Terminating.</font>")
		else if(!recharge_port)
			mecha.occupant_message("<font color='red'>Power port not found. Terminating.</font>")
	return

/turf/simulated/floor/mech_bay_recharge_floor/Exited(atom)
	. = ..()
	if(atom == recharging_mecha)
		recharging_mecha = null
		if(recharge_console)
			recharge_console.mecha_out()
	return

/turf/simulated/floor/mech_bay_recharge_floor/proc/init_devices()
	if(!recharge_console)
		recharge_console = locate() in range(1,src)
	if(!recharge_port)
		recharge_port = locate() in get_step(src, WEST)

	if(recharge_console)
		recharge_console.recharge_floor = src
		if(recharge_port)
			recharge_console.recharge_port = recharge_port
	if(recharge_port)
		recharge_port.recharge_floor = src
		if(recharge_console)
			recharge_port.recharge_console = recharge_console
	return

// temporary fix for broken icon until somebody gets around to make these player-buildable
/turf/simulated/floor/mech_bay_recharge_floor/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(floor_type)
		icon_state = "recharge_floor"
	else
		icon_state = "support_lattice"


/obj/machinery/mech_bay_recharge_port
	name = "Mech Bay Power Port"
	density = 1
	anchored = 1
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_port"
	var/turf/simulated/floor/mech_bay_recharge_floor/recharge_floor
	var/obj/machinery/computer/mech_bay_power_console/recharge_console
	var/datum/global_iterator/mech_bay_recharger/pr_recharger

/obj/machinery/mech_bay_recharge_port/New()
	..()
	pr_recharger = new /datum/global_iterator/mech_bay_recharger(null,0)
	return

/obj/machinery/mech_bay_recharge_port/proc/start_charge(var/obj/mecha/recharging_mecha)
	if(stat&(NOPOWER|BROKEN))
		recharging_mecha.occupant_message("<font color='red'>Power port not responding. Terminating.</font>")
		return 0
	else
		if(recharging_mecha.cell)
			recharging_mecha.occupant_message("Now charging...")
			pr_recharger.start(list(src,recharging_mecha))
			return 1
		else
			return 0

/obj/machinery/mech_bay_recharge_port/proc/stop_charge()
	if(recharge_console && !recharge_console.stat)
		recharge_console.icon_screen = initial(recharge_console.icon_screen)
	pr_recharger.stop()
	return

/obj/machinery/mech_bay_recharge_port/proc/active()
	if(pr_recharger.active())
		return 1
	else
		return 0

/obj/machinery/mech_bay_recharge_port/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			pr_recharger.stop()
	return

/obj/machinery/mech_bay_recharge_port/proc/set_voltage(new_voltage)
	if(new_voltage && isnum(new_voltage))
		pr_recharger.max_charge = new_voltage
		return 1
	else
		return 0


/datum/global_iterator/mech_bay_recharger
	delay = 20
	var/max_charge = 45
	check_for_null = 0 //since port.stop_charge() must be called. The checks are made in process()

/datum/global_iterator/mech_bay_recharger/process(var/obj/machinery/mech_bay_recharge_port/port, var/obj/mecha/mecha)
	if(!port)
		return 0
	if(mecha && mecha in port.recharge_floor)
		if(!mecha.cell)
			return
		var/delta = min(max_charge, mecha.cell.maxcharge - mecha.cell.charge)
		if(delta>0)
			mecha.give_power(delta)
			port.use_power(delta*150)
		else
			mecha.occupant_message("<font color='blue'><b>Fully charged.</b></font>")
			port.stop_charge()
	else
		port.stop_charge()
	return


/obj/machinery/computer/mech_bay_power_console
	name = "Mech Bay Power Control Console"
	density = 1
	anchored = 1
	icon_keyboard = "tech_key"
	icon_screen = "recharge_comp"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/mech_bay_power_console
	var/autostart = 1
	var/voltage = 45
	var/turf/simulated/floor/mech_bay_recharge_floor/recharge_floor
	var/obj/machinery/mech_bay_recharge_port/recharge_port

/obj/machinery/computer/mech_bay_power_console/proc/mecha_in(var/obj/mecha/mecha)
	if(stat&(NOPOWER|BROKEN))
		mecha.occupant_message("<font color='red'>Control console not responding. Terminating...</font>")
		return
	if(recharge_port && autostart)
		var/answer = recharge_port.start_charge(mecha)
		if(answer)
			recharge_port.set_voltage(voltage)
			src.icon_screen = initial(src.icon_screen)+"_on"
	return

/obj/machinery/computer/mech_bay_power_console/proc/mecha_out()
	if(recharge_port)
		recharge_port.stop_charge()
	return

/obj/machinery/computer/mech_bay_power_console/attack_hand(mob/user as mob)
	if(..())
		return
	if(!recharge_floor || !recharge_port)
		var/turf/simulated/floor/mech_bay_recharge_floor/F = locate() in range(1,src)
		if(F)
			F.init_devices()
	ui_interact(user)

/obj/machinery/computer/mech_bay_power_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	data["has_floor"] = recharge_floor
	data["has_port"] = recharge_port
	if(recharge_floor && recharge_floor.recharging_mecha && recharge_floor.recharging_mecha.cell)
		data["has_mech"] = 1
		data["mecha_name"] = recharge_floor.recharging_mecha || "None"
		data["mecha_charge"] = isnull(recharge_floor.recharging_mecha) ? 0 : recharge_floor.recharging_mecha.cell.charge
		data["mecha_maxcharge"] = isnull(recharge_floor.recharging_mecha) ? 0 : recharge_floor.recharging_mecha.cell.maxcharge
		data["mecha_charge_percentage"] = isnull(recharge_floor.recharging_mecha) ? 0 : round(recharge_floor.recharging_mecha.cell.percent())
	else
		data["has_mech"] = 0
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "mech_bay_console.tmpl", "Mech Bay Control Console", 500, 325)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)
