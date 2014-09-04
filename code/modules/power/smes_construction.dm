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
	var/max_coils = 6 			//30M capacity, 1.5MW input/output when fully upgraded /w default coils
	var/cur_coils = 1 			// Current amount of installed coils
	var/safeties_enabled = 1 	// If 0 modifications can be done without discharging the SMES, at risk of critical failure.
	var/failing = 0 			// If 1 critical failure has occured and SMES explosion is imminent.

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

	// SMESs store very large amount of power. If someone screws up (ie: Disables safeties and attempts to modify the SMES) very bad things happen.
	// Bad things are based on charge percentage.
	// Possible effects:
	// Sparks - Lets out few sparks, mostly fire hazard if phoron present. Otherwise purely aesthetic.
	// Shock - Depending on intensity harms the user. Insultated Gloves protect against weaker shocks, but strong shock bypasses them.
	// EMP Pulse - Lets out EMP pulse discharge which screws up nearby electronics.
	// Light Overload - X% chance to overload each lighting circuit in connected powernet. APC based.
	// APC Failure - X% chance to destroy APC causing very weak explosion too. Won't cause hull breach or serious harm.
	// SMES Explosion - X% chance to destroy the SMES, in moderate explosion. May cause small hull breach.
/obj/machinery/power/smes/buildable/proc/total_system_failure(var/intensity = 0, var/mob/user as mob)
	if (!intensity)
		return

	var/mob/living/carbon/human/h_user = null
	if (!istype(user, /mob/living/carbon/human))
		return
	else
		h_user = user


	// Preparations
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	// Check if user has protected gloves.
	var/user_protected = 0
	if(h_user.gloves)
		var/obj/item/clothing/gloves/G = h_user.gloves
		if(G.siemens_coefficient == 0)
			user_protected = 1


	switch (intensity)
		if (0 to 15)
			// Small overcharge
			// Sparks, Weak shock
			s.set_up(2, 1, src)
			s.start()
			if (user_protected && prob(80))
				h_user << "Small electrical arc almost burns your hand. Luckily you had your gloves on!"
			else
				h_user << "Small electrical arc sparks and burns your hand as you touch the [src]!"
				h_user.adjustFireLoss(rand(5,10))
				h_user.Paralyse(2)
			charge = 0

		if (16 to 35)
			// Medium overcharge
			// Sparks, Medium shock, Weak EMP
			s.set_up(4,1,src)
			s.start()
			if (user_protected && prob(25))
				h_user << "Medium electrical arc sparks and almost burns your hand. Luckily you had your gloves on!"
			else
				h_user << "Medium electrical sparks as you touch the [src], severely burning your hand!"
				h_user.adjustFireLoss(rand(10,25))
				h_user.Paralyse(5)
			empulse(src.loc, 2, 4)
			charge = 0

		if (36 to 60)
			// Strong overcharge
			// Sparks, Strong shock, Strong EMP, 10% light overload. 1% APC failure
			s.set_up(7,1,src)
			s.start()
			if (user_protected)
				h_user << "Strong electrical arc sparks between you and [src], ignoring your gloves and burning your hand!"
				h_user.adjustFireLoss(rand(25,60))
				h_user.Paralyse(8)
			else
				h_user << "Strong electrical arc sparks between you and [src], knocking you out for a while!"
				h_user.adjustFireLoss(rand(35,75))
				h_user.Paralyse(12)
			empulse(src.loc, 8, 16)
			charge = 0
			apcs_overload(1, 10)
			src.visible_message("\icon[src] <b>[src]</b> beeps: \"Caution. Output regulators malfunction. Uncontrolled discharge detected.\"")

		if (61 to INFINITY)
			// Massive overcharge
			// Sparks, Near - instantkill shock, Strong EMP, 25% light overload, 5% APC failure. 50% of SMES explosion. This is bad.
			s.set_up(10,1,src)
			s.start()
			h_user << "Massive electrical arc sparks between you and [src]. Last thing you can think about is \"Oh shit...\""
			// Remember, we have few gigajoules of electricity here.. Turn them into crispy toast.
			h_user.adjustFireLoss(rand(150,195))
			h_user.Paralyse(25)
			empulse(src.loc, 32, 64)
			charge = 0
			apcs_overload(5, 25)
			src.visible_message("\icon[src] <b>[src]</b> beeps: \"Caution. Output regulators malfunction. Significant uncontrolled discharge detected.\"")

			if (prob(50))
				src.visible_message("\icon[src] <b>[src]</b> beeps: \"DANGER! Magnetic containment field unstable! Containment field failure imminent!\"")
				failing = 1
				// 30 - 60 seconds and then BAM!
				spawn(rand(300,600))
					src.visible_message("\icon[src] <b>[src]</b> beeps: \"DANGER! Magnetic containment field failure in 3 ... 2 ... 1 ...\"")
					explosion(src.loc,1,2,4,8)
					// Not sure if this is necessary, but just in case the SMES *somehow* survived..
					del(src)



	// Gets powernet APCs and overloads lights or breaks the APC completely, depending on percentages.
/obj/machinery/power/smes/buildable/proc/apcs_overload(var/failure_chance, var/overload_chance)
	if (!src.powernet)
		return

	for(var/obj/machinery/power/terminal/T in src.powernet.nodes)
		if(istype(T.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = T.master
			if (prob(overload_chance))
				A.overload_lighting()
			else if (prob(failure_chance))
				A.set_broken()

	// Failing SMES has special icon overlay.
/obj/machinery/power/smes/buildable/updateicon()
	if (failing)
		overlays.Cut()
		overlays += image('icons/obj/power.dmi', "smes-crit")
	else
		..()

/obj/machinery/power/smes/buildable/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	// If parent returned 1:
	// - Hatch is open, so we can modify the SMES
	// - No action was taken in parent function (terminal de/construction atm).
	if (..())

		// Charged above 1% and safeties are enabled.
		if((charge > (capacity/100)) && safeties_enabled && (!istype(W, /obj/item/device/multitool)))
			user << "<span class='warning'>Safety circuit of [src] is preventing modifications while it's charged!</span>"
			return

		if (online || chargemode)
			user << "<span class='warning'>Turn off the [src] first!</span>"
			return

		// Probability of failure if safety circuit is disabled (in %)
		var/failure_probability = round((charge / capacity) * 100)

		// If failure probability is below 5% it's usually safe to do modifications
		if (failure_probability < 5)
			failure_probability = 0

		// Crowbar - Disassemble the SMES.
		if(istype(W, /obj/item/weapon/crowbar))
			if (terminal)
				user << "<span class='warning'>You have to disassemble the terminal first!</span>"
				return

			playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
			user << "<span class='warning'>You begin to disassemble the [src]!</span>"
			if (do_after(usr, 100 * cur_coils)) // More coils = takes longer to disassemble. It's complex so largest one with 5 coils will take 50s

				if (failure_probability && prob(failure_probability))
					total_system_failure(failure_probability, user)
					return

				usr << "\red You have disassembled the SMES cell!"
				var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
				M.state = 2
				M.icon_state = "box_1"
				for(var/obj/I in component_parts)
					if(I.reliability != 100 && crit_fail)
						I.crit_fail = 1
						I.loc = src.loc
				del(src)
				return

		// Superconducting Magnetic Coil - Upgrade the SMES
		else if(istype(W, /obj/item/weapon/smes_coil))
			if (cur_coils < max_coils)

				if (failure_probability && prob(failure_probability))
					total_system_failure(failure_probability, user)
					return

				usr << "You install the coil into the SMES unit!"
				user.drop_item()
				cur_coils ++
				component_parts += W
				W.loc = src
				recalc_coils()
			else
				usr << "\red You can't insert more coils to this SMES unit!"

		// Multitool - Toggle the safeties.
		else if(istype(W, /obj/item/device/multitool))
			safeties_enabled = !safeties_enabled
			user << "<span class='warning'>You [safeties_enabled ? "connected" : "disconnected"] the safety circuit.</span>"
			src.visible_message("\icon[src] <b>[src]</b> beeps: \"Caution. Safety circuit has been: [safeties_enabled ? "re-enabled" : "disabled. Please excercise caution."]\"")
