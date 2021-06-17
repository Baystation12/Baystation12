/obj/machinery/space_heater
	use_power = POWER_USE_OFF
	anchored = FALSE
	density = TRUE
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set anything, or anyone, on fire."
	var/obj/item/cell/cell
	var/on = 0
	var/set_temperature = T0C + 20	//K
	var/active = 0
	var/heating_power = 40 KILOWATTS
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	clicksound = "switch"


/obj/machinery/space_heater/New()
	..()
	cell = new/obj/item/cell/high(src)
	update_icon()

/obj/machinery/space_heater/on_update_icon(var/rebuild_overlay = 0)
	if(!on)
		icon_state = "sheater-off"
		set_light(0)
	else if(active > 0)
		icon_state = "sheater-heat"
		set_light(0.7, 1, 2, 3, COLOR_SEDONA)
	else if(active < 0)
		icon_state = "sheater-cool"
		set_light(0.7, 1, 2, 3, COLOR_DEEP_SKY_BLUE)
	else
		icon_state = "sheater-standby"
		set_light(0)

	if(rebuild_overlay)
		overlays.Cut()
		if(panel_open)
			overlays  += "sheater-open"

/obj/machinery/space_heater/examine(mob/user)
	. = ..()

	to_chat(user, "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"].")
	if(panel_open)
		to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
	else
		to_chat(user, "The charge meter reads [cell ? round(cell.percent(),1) : 0]%")

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				if(!user.unEquip(I, src))
					return
				cell = I
				user.visible_message("<span class='notice'>[user] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")
				power_change()
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(isScrewdriver(I))
		panel_open = !panel_open
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon(1)
		if(!panel_open && user.machine == src)
			show_browser(user, null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/interface_interact(mob/user)
	if(panel_open)
		interact(user)
		return TRUE

/obj/machinery/space_heater/interact(mob/user)
	if(panel_open)
		var/list/dat = list()
		dat += "Power cell: "
		if(cell)
			dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=cellinstall'>Removed</A><BR>"

		dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

		dat += "Set Temperature: "

		dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

		dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
		dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

		var/datum/browser/popup = new(usr, "spaceheater", "Space Heater Control Panel")
		popup.set_content(jointext(dat, null))
		popup.set_title_image(usr.browse_rsc_icon(src.icon, "sheater-standby"))
		popup.open()

	return

/obj/machinery/space_heater/physical_attack_hand(mob/user)
	if(!panel_open)
		on = !on
		user.visible_message("<span class='notice'>[user] switches [on ? "on" : "off"] the [src].</span>","<span class='notice'>You switch [on ? "on" : "off"] the [src].</span>")
		update_icon()
		return TRUE

/obj/machinery/space_heater/Topic(href, href_list, state = GLOB.physical_state)
	if (..())
		show_browser(usr, null, "window=spaceheater")
		usr.unset_machine()
		return 1

	switch(href_list["op"])

		if("temp")
			var/value = text2num(href_list["val"])

			// limit to 0-90 degC
			set_temperature = dd_range(T0C, T0C + 90, set_temperature + value)

		if("cellremove")
			if(panel_open && cell && !usr.get_active_hand())
				usr.visible_message("<span class='notice'>\The usr] removes \the [cell] from \the [src].</span>", "<span class='notice'>You remove \the [cell] from \the [src].</span>")
				cell.update_icon()
				usr.put_in_hands(cell)
				cell.add_fingerprint(usr)
				cell = null
				power_change()

		if("cellinstall")
			if(panel_open && !cell)
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					if(!usr.unEquip(C, src))
						return
					cell = C
					C.add_fingerprint(usr)
					power_change()
					usr.visible_message("<span class='notice'>[usr] inserts \the [C] into \the [src].</span>", "<span class='notice'>You insert \the [C] into \the [src].</span>")

	updateDialog()

/obj/machinery/space_heater/Process()
	if(on)
		if(powered() || (cell && cell.charge))
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) <= 0.1)
				active = 0
			else
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					var/power_draw
					if(heat_transfer > 0)	//heating air
						heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

						removed.add_thermal_energy(heat_transfer)
						power_draw = heat_transfer
					else	//cooling air
						heat_transfer = abs(heat_transfer)

						//Assume the heat is being pumped into the hull which is fixed at 20 C
						var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
						heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

						power_draw = abs(heat_transfer)/cop
					if(!powered())
						cell.use(power_draw*CELLRATE)
					else
						use_power_oneoff(power_draw)
					active = heat_transfer

				env.merge(removed)
		else
			on = 0
			active = 0
			power_change()
		update_icon()
