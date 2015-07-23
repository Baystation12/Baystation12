/obj/machinery/mech_bay_recharge_port
	name = "Mech Bay Power Port"
	density = 1
	anchored = 1
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_port"
	var/turf/simulated/floor/recharge_floor
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
		recharge_console.icon_state = initial(recharge_console.icon_state)
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
	icon = 'icons/obj/computer.dmi'
	icon_state = "recharge_comp"
	light_color = "#a97faa"
	circuit = "/obj/item/weapon/circuitboard/mech_bay_power_console"
	var/autostart = 1
	var/voltage = 45
	var/turf/simulated/floor/recharge_floor
	var/obj/machinery/mech_bay_recharge_port/recharge_port

/obj/machinery/computer/mech_bay_power_console/proc/mecha_in(var/obj/mecha/mecha)
	if(stat&(NOPOWER|BROKEN))
		mecha.occupant_message("<font color='red'>Control console not responding. Terminating...</font>")
		return
	if(recharge_port && autostart)
		var/answer = recharge_port.start_charge(mecha)
		if(answer)
			recharge_port.set_voltage(voltage)
			src.icon_state = initial(src.icon_state)+"_on"
	return

/obj/machinery/computer/mech_bay_power_console/proc/mecha_out()
	if(recharge_port)
		recharge_port.stop_charge()
	return


/obj/machinery/computer/mech_bay_power_console/power_change()
	if(stat & BROKEN)
		icon_state = initial(icon_state)+"_broken"
		if(recharge_port)
			recharge_port.stop_charge()
	else if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			icon_state = initial(icon_state)+"_nopower"
			stat |= NOPOWER
			if(recharge_port)
				recharge_port.stop_charge()

/obj/machinery/computer/mech_bay_power_console/set_broken()
	icon_state = initial(icon_state)+"_broken"
	stat |= BROKEN
	if(recharge_port)
		recharge_port.stop_charge()

/obj/machinery/computer/mech_bay_power_console/attack_hand(mob/user as mob)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/mech_bay_power_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	return