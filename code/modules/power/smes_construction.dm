// BUILDABLE SMES(Superconducting Magnetic Energy Storage) UNIT
//
// Last Change 1.1.2015 by Atlantis - Happy New Year!
//
// This is subtype of SMES that should be normally used. It can be constructed, deconstructed and hacked.
// It also supports RCON System which allows you to operate it remotely, if properly set.

//Construction Item
/obj/item/weapon/smes_coil
	name = "superconductive magnetic coil"
	desc = "Heavy duty superconductive magnetic coil, mainly used in construction of SMES units."
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
	var/datum/wires/smes/wires
	var/grounding = 1			// Cut to quickly discharge, at cost of "minor" electrical issues in output powernet.
	var/RCon = 1				// Cut to disable AI and remote control.
	var/RCon_tag = "NO_TAG"		// RCON tag, change to show it on SMES Remote control console.
	charge = 0
	should_be_mapped = 1

// Proc: process()
// Parameters: None
// Description: Uses parent process, but if grounding wire is cut causes sparks to fly around.
// This also causes the SMES to quickly discharge, and has small chance of damaging output APCs.
/obj/machinery/power/smes/buildable/process()
	if(!grounding && (Percentage() > 5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		charge -= (output_level_max * SMESRATE)
		if(prob(1)) // Small chance of overload occuring since grounding is disabled.
			apcs_overload(5,10)

	..()

// Proc: attack_ai()
// Parameters: None
// Description: AI requires the RCON wire to be intact to operate the SMES.
/obj/machinery/power/smes/buildable/attack_ai()
	if(RCon)
		..()
	else // RCON wire cut
		usr << "<span class='warning'>Connection error: Destination Unreachable.</span>"

// Proc: New()
// Parameters: None
// Description: Adds standard components for this SMES, and forces recalculation of properties.
/obj/machinery/power/smes/buildable/New()
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src,30)
	component_parts += new /obj/item/weapon/circuitboard/smes(src)
	src.wires = new /datum/wires/smes(src)

	// Allows for mapped-in SMESs with larger capacity/IO
	for(var/i = 1, i <= cur_coils, i++)
		component_parts += new /obj/item/weapon/smes_coil(src)

	recalc_coils()
	..()

// Proc: attack_hand()
// Parameters: None
// Description: Opens the UI as usual, and if cover is removed opens the wiring panel.
/obj/machinery/power/smes/buildable/attack_hand()
	..()
	if(open_hatch)
		wires.Interact(usr)

// Proc: recalc_coils()
// Parameters: None
// Description: Updates properties (IO, capacity, etc.) of this SMES by checking internal components.
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

// Proc: total_system_failure()
// Parameters: 2 (intensity - how strong the failure is, user - person which caused the failure)
// Description: Checks the sensors for alerts. If change (alerts cleared or detected) occurs, calls for icon update.
/obj/machinery/power/smes/buildable/proc/total_system_failure(var/intensity = 0, var/mob/user as mob)
	// SMESs store very large amount of power. If someone screws up (ie: Disables safeties and attempts to modify the SMES) very bad things happen.
	// Bad things are based on charge percentage.
	// Possible effects:
	// Sparks - Lets out few sparks, mostly fire hazard if phoron present. Otherwise purely aesthetic.
	// Shock - Depending on intensity harms the user. Insultated Gloves protect against weaker shocks, but strong shock bypasses them.
	// EMP Pulse - Lets out EMP pulse discharge which screws up nearby electronics.
	// Light Overload - X% chance to overload each lighting circuit in connected powernet. APC based.
	// APC Failure - X% chance to destroy APC causing very weak explosion too. Won't cause hull breach or serious harm.
	// SMES Explosion - X% chance to destroy the SMES, in moderate explosion. May cause small hull breach.

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
	log_game("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [usr.ckey], Intensity: [intensity]/100")
	message_admins("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [usr.ckey], Intensity: [intensity]/100 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>")


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
			spawn(0)
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
			spawn(0)
				empulse(src.loc, 8, 16)
			charge = 0
			apcs_overload(1, 10)
			src.ping("Caution. Output regulators malfunction. Uncontrolled discharge detected.")

		if (61 to INFINITY)
			// Massive overcharge
			// Sparks, Near - instantkill shock, Strong EMP, 25% light overload, 5% APC failure. 50% of SMES explosion. This is bad.
			s.set_up(10,1,src)
			s.start()
			h_user << "Massive electrical arc sparks between you and [src]. Last thing you can think about is \"Oh shit...\""
			// Remember, we have few gigajoules of electricity here.. Turn them into crispy toast.
			h_user.adjustFireLoss(rand(150,195))
			h_user.Paralyse(25)
			spawn(0)
				empulse(src.loc, 32, 64)
			charge = 0
			apcs_overload(5, 25)
			src.ping("Caution. Output regulators malfunction. Significant uncontrolled discharge detected.")

			if (prob(50))
				// Added admin-notifications so they can stop it when griffed.
				log_game("SMES explosion imminent.")
				message_admins("SMES explosion imminent.")
				src.ping("DANGER! Magnetic containment field unstable! Containment field failure imminent!")
				failing = 1
				// 30 - 60 seconds and then BAM!
				spawn(rand(300,600))
					if(!failing) // Admin can manually set this var back to 0 to stop overload, for use when griffed.
						update_icon()
						src.ping("Magnetic containment stabilised.")
						return
					src.ping("DANGER! Magnetic containment field failure in 3 ... 2 ... 1 ...")
					explosion(src.loc,1,2,4,8)
					// Not sure if this is necessary, but just in case the SMES *somehow* survived..
					del(src)



// Proc: apcs_overload()
// Parameters: 2 (failure_chance - chance to actually break the APC, overload_chance - Chance of breaking lights)
// Description: Damages output powernet by power surge. Destroys few APCs and lights, depending on parameters.
/obj/machinery/power/smes/buildable/proc/apcs_overload(var/failure_chance, var/overload_chance)
	if (!src.powernet)
		return

	for(var/obj/machinery/power/terminal/T in src.powernet.nodes)
		if(istype(T.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = T.master
			if (prob(overload_chance))
				A.overload_lighting()
			if (prob(failure_chance))
				A.set_broken()

// Proc: update_icon()
// Parameters: None
// Description: Allows us to use special icon overlay for critical SMESs
/obj/machinery/power/smes/buildable/update_icon()
	if (failing)
		overlays.Cut()
		overlays += image('icons/obj/power.dmi', "smes-crit")
	else
		..()

// Proc: attackby()
// Parameters: 2 (W - object that was used on this machine, user - person which used the object)
// Description: Handles tool interaction. Allows deconstruction/upgrading/fixing.
/obj/machinery/power/smes/buildable/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	// No more disassembling of overloaded SMESs. You broke it, now enjoy the consequences.
	if (failing)
		user << "<span class='warning'>The [src]'s screen is flashing with alerts. It seems to be overloaded! Touching it now is probably not a good idea.</span>"
		return
	// If parent returned 1:
	// - Hatch is open, so we can modify the SMES
	// - No action was taken in parent function (terminal de/construction atm).
	if (..())

		// Multitool - change RCON tag
		if(istype(W, /obj/item/device/multitool))
			var/newtag = input(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system") as text
			if(newtag)
				RCon_tag = newtag
				user << "<span class='notice'>You changed the RCON tag to: [newtag]</span>"
			return
		// Charged above 1% and safeties are enabled.
		if((charge > (capacity/100)) && safeties_enabled)
			user << "<span class='warning'>Safety circuit of [src] is preventing modifications while it's charged!</span>"
			return

		if (output_attempt || input_attempt)
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

// Proc: toggle_input()
// Parameters: None
// Description: Switches the input on/off depending on previous setting
/obj/machinery/power/smes/buildable/proc/toggle_input()
	inputting(!input_attempt)
	update_icon()

// Proc: toggle_output()
// Parameters: None
// Description: Switches the output on/off depending on previous setting
/obj/machinery/power/smes/buildable/proc/toggle_output()
	outputting(!output_attempt)
	update_icon()

// Proc: set_input()
// Parameters: 1 (new_input - New input value in Watts)
// Description: Sets input setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/buildable/proc/set_input(var/new_input = 0)
	input_level = between(0, new_input, input_level_max)
	update_icon()

// Proc: set_output()
// Parameters: 1 (new_output - New output value in Watts)
// Description: Sets output setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/buildable/proc/set_output(var/new_output = 0)
	output_level = between(0, new_output, output_level_max)
	update_icon()