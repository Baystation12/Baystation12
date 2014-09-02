// Constructable SMES version. Based on Coils. Each SMES can hold 6 Coils by default.
// Each coil adds 250kW I/O and 5M capacity.
// This is second version, now subtype of regular SMES.


//Board
/obj/item/weapon/circuitboard/smes
	name = "Circuit board (SMES Cell)"
	build_path = "/obj/machinery/power/smes/buildable"
	board_type = "machine"
	origin_tech = "powerstorage=6;engineering=4" // Board itself is high tech. Coils have to be ordered from cargo or salvaged from existing SMESs.
	frame_desc = "Requires 1 superconducting magnetic coil and 30 wires."
	req_components = list("/obj/item/weapon/smes_coil" = 1, "/obj/item/stack/cable_coil" = 30)

//Construction Item
/obj/item/weapon/smes_coil
	name = "Superconducting Magnetic Coil"
	desc = "Heavy duty superconducting magnetic coil, mainly used in construction of SMES units."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"			// Just few icons patched together. If someone wants to make better icon, feel free to do so!
	w_class = 4.0 						// It's LARGE (backpack size)
	var/ChargeCapacity = 5000000
	var/IOCapacity = 250000




// SMES itself
/obj/machinery/power/smes/buildable
	var/max_coils = 6 //30M capacity, 1.5MW input/output when fully upgraded /w default coils
	var/cur_coils = 1 // Current amount of installed coils

/obj/machinery/power/smes/buildable/New()
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src,30)
	component_parts += new /obj/item/weapon/circuitboard/smes(src)

	// Allows for mapped-in SMESs with larger capacity/IO
	for(var/i = 1, i <= cur_coils, i++)
		component_parts += new /obj/item/weapon/smes_coil(src)

	recalc_coils()
	..()

/obj/machinery/power/smes/buildable/proc/recalc_coils()
	if ((cur_coils <= max_coils) && (cur_coils >= 1))
		capacity = 0
		input_level_max = 0
		output_level_max = 0
		for(var/obj/item/weapon/smes_coil/C in component_parts)
			capacity += C.ChargeCapacity
			input_level_max += C.IOCapacity
			output_level_max += C.IOCapacity
		charge = between(0, charge, capacity)
		return 1
	else
		return 0

/obj/machinery/power/smes/buildable/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()
	if(open_hatch)
		if(istype(W, /obj/item/weapon/crowbar))
			if (charge < (capacity / 100))
				if (!online && !chargemode)
					if (!terminal)
						playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
						usr << "\red You begin to disassemble the SMES cell!"
						if (do_after(usr, 100 * cur_coils)) // More coils = takes longer to disassemble. It's complex so largest one with 5 coils will take 50s
							usr << "\red You have disassembled the SMES cell!"
							var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
							M.state = 2
							M.icon_state = "box_1"
							for(var/obj/I in component_parts)
								if(I.reliability != 100 && crit_fail)
									I.crit_fail = 1
								I.loc = src.loc
							del(src)
						return 1
					else
						user << "<span class='warning'>You have to disassemble the terminal first!</span>"
				else
					user << "<span class='warning'>Turn off the [src] before dismantling it.</span>"
			else
				user << "<span class='warning'>Better let [src] discharge before dismantling it.</span>"

		else if(istype(W, /obj/item/weapon/smes_coil) && !(istype(src, /obj/machinery/power/smes/batteryrack)))
			if (cur_coils < max_coils)
				usr << "You install the coil into the SMES unit!"
				user.drop_item()
				cur_coils ++
				component_parts += W
				W.loc = src
				recalc_coils()
			else
				usr << "\red You can't insert more coils to this SMES unit!"
		else
	user  << "<span class='warning'>You need to open access hatch on [src] first!</spawn>"