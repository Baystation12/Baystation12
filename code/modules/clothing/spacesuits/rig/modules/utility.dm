/* Contains:
 * /obj/item/rig_module/device
 * /obj/item/rig_module/device/healthscanner
 * /obj/item/rig_module/device/defib
 * /obj/item/rig_module/device/drill
 * /obj/item/rig_module/device/orescanner
 * /obj/item/rig_module/device/rcd
 * /obj/item/rig_module/device/anomaly_scanner
 * /obj/item/rig_module/maneuvering_jets
 * /obj/item/rig_module/chem_dispenser
 * /obj/item/rig_module/chem_dispenser/injector
 * /obj/item/rig_module/voice
 * /obj/item/rig_module/device/paperdispenser
 * /obj/item/rig_module/device/pen
 * /obj/item/rig_module/device/stamp
 */

/obj/item/rig_module/device
	name = "mounted device"
	desc = "Some kind of hardsuit mount."
	usable = 0
	selectable = 1
	toggleable = 0
	disruptive = 0

	var/obj/item/device

/obj/item/rig_module/device/healthscanner
	name = "health scanner module"
	desc = "A hardsuit-mounted health scanner."
	icon_state = "scanner"
	interface_name = "health scanner"
	interface_desc = "Shows an informative health readout when used on a subject."
	engage_string = "Display Readout"
	usable = 1
	use_power_cost = 200
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	device = /obj/item/device/scanner/health

/obj/item/rig_module/device/defib
	name = "mounted defibrillator"
	desc = "A complex Vey-Med circuit with two metal electrodes hanging from it."
	icon_state = "defib"

	interface_name = "mounted defibrillator"
	interface_desc = "A prototype defibrillator, palm-mounted for ease of use."

	use_power_cost = 0//Already handled by defib, but it's 150 Wh, normal defib takes 100
	device = /obj/item/shockpaddles/rig

/obj/item/rig_module/device/drill
	name = "hardsuit mounted drill"
	desc = "A very heavy diamond-tipped drill."
	icon_state = "drill"
	interface_name = "mounted drill"
	interface_desc = "A diamond-tipped industrial drill."
	suit_overlay_active = "mounted-drill"
	suit_overlay_inactive = null
	use_power_cost = 3600 //2 Wh per use
	module_cooldown = 0
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 6)
	device = /obj/item/pickaxe/diamonddrill

/obj/item/rig_module/device/anomaly_scanner
	name = "anomaly scanner module"
	desc = "You think it's called an Elder Sarsparilla or something."
	icon_state = "eldersasparilla"
	interface_name = "Alden-Saraspova counter"
	interface_desc = "An exotic particle detector commonly used by xenoarchaeologists."
	engage_string = "Begin Scan"
	use_power_cost = 200
	usable = 1
	selectable = 0
	device = /obj/item/device/ano_scanner
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)

/obj/item/rig_module/device/orescanner
	name = "ore scanner module"
	desc = "A clunky old ore scanner."
	icon_state = "scanner"
	interface_name = "ore detector"
	interface_desc = "A sonar system for detecting large masses of ore."
	activate_string = "Get Survey Data Disk"
	engage_string = "Display Readout"
	usable = 1
	toggleable = 1
	use_power_cost = 200
	device = /obj/item/device/scanner/mining
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)

/obj/item/rig_module/device/orescanner/activate()
	if(!check() || !device)
		return 0

	var/obj/item/device/scanner/mining/scanner = device
	scanner.put_disk_in_hand(holder.wearer)

/obj/item/rig_module/device/rcd
	name = "\improper RCD mount"
	desc = "A cell-powered rapid construction device for a hardsuit."
	icon_state = "rcd"
	interface_name = "mounted RCD"
	interface_desc = "A device for building or removing walls. Cell-powered."
	usable = 1
	engage_string = "Configure RCD"
	use_power_cost = 300
	origin_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 7)
	device = /obj/item/rcd/mounted

/obj/item/rig_module/device/Initialize()
	. = ..()
	if(ispath(device))
		device = new device(src)
		device.canremove = 0

/obj/item/rig_module/device/engage(atom/target)
	if(!..() || !device)
		return 0

	if(!target)
		device.attack_self(holder.wearer)
		return 1

	if(!target.Adjacent(holder.wearer))
		return 0

	var/mob/user = holder.wearer
	device.resolve_attackby(target, user)
	return 1


/obj/item/rig_module/chem_dispenser
	name = "mounted chemical dispenser"
	desc = "A complex web of tubing and needles suitable for hardsuit use."
	icon_state = "injector"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0
	use_power_cost = 500

	engage_string = "Inject"

	interface_name = "integrated chemical dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream."

	charges = list(
		list("dexalin plus",  "dexalin plus",  /datum/reagent/dexalinp,          80),
		list("inaprovaline",  "inaprovaline",  /datum/reagent/inaprovaline,      80),
		list("dylovene",      "dylovene",      /datum/reagent/dylovene,          80),
		list("hyronalin",     "hyronalin",     /datum/reagent/hyronalin,         80),
		list("spaceacillin",  "spaceacillin",  /datum/reagent/spaceacillin,      80),
		list("tramadol",      "tramadol",      /datum/reagent/tramadol,          80)
		)

	var/max_reagent_volume = 80 //Used when refilling.

/obj/item/rig_module/chem_dispenser/ninja
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream. This variant is made to be extremely light and flexible."

	//just over a syringe worth of each. Want more? Go refill. Gives the ninja another reason to have to show their face.
	charges = list(
		list("dexalin plus",  "dexalin plus",  /datum/reagent/dexalinp,          20),
		list("inaprovaline",  "inaprovaline",  /datum/reagent/inaprovaline,      20),
		list("dylovene",      "dylovene",      /datum/reagent/dylovene,          20),
		list("glucose",       "glucose",       /datum/reagent/nutriment/glucose, 80),
		list("hyronalin",     "hyronalin",     /datum/reagent/hyronalin,         20),
		list("bicaridine",    "bicaridine",    /datum/reagent/bicaridine,        20),
		list("dermaline",     "dermaline",     /datum/reagent/dermaline,         20),
		list("spaceacillin",  "spaceacillin",  /datum/reagent/spaceacillin,      20),
		list("coagulant",     "coagulant",     /datum/reagent/coagulant,         20),
		list("tramadol",      "tramadol",      /datum/reagent/tramadol,          20)
		)

/obj/item/rig_module/chem_dispenser/accepts_item(obj/item/input_item, mob/living/user)

	if(!input_item.is_open_container())
		return 0

	if(!input_item.reagents || !input_item.reagents.total_volume)
		to_chat(user, "\The [input_item] is empty.")
		return 0

	// Magical chemical filtration system, do not question it.
	var/total_transferred = 0
	for(var/datum/reagent/R in input_item.reagents.reagent_list)
		for(var/chargetype in charges)
			var/datum/rig_charge/charge = charges[chargetype]
			if(charge.product_type == R.type)

				var/chems_to_transfer = R.volume

				if((charge.charges + chems_to_transfer) > max_reagent_volume)
					chems_to_transfer = max_reagent_volume - charge.charges

				charge.charges += chems_to_transfer
				input_item.reagents.remove_reagent(R.type, chems_to_transfer)
				total_transferred += chems_to_transfer

				break

	if(total_transferred)
		to_chat(user, SPAN_INFO("You transfer [total_transferred] units into the suit reservoir."))
	else
		to_chat(user, SPAN_DANGER("None of the reagents seem suitable."))
	return 1

/obj/item/rig_module/chem_dispenser/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, SPAN_DANGER("You have not selected a chemical type."))
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	var/chems_to_use = 5
	if(charge.charges <= 0)
		to_chat(H, SPAN_DANGER("Insufficient chems!"))
		return 0
	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(target)
		if(istype(target,/mob/living/carbon))
			target_mob = target
		else
			return 0
	else
		target_mob = H

	if(target_mob != H)
		to_chat(H, SPAN_DANGER("You inject [target_mob] with [chems_to_use] unit\s of [charge.display_name]."))
	to_chat(target_mob, SPAN_CLASS("danger", "You feel a rushing in your veins as [chems_to_use] unit\s of [charge.display_name] [chems_to_use == 1 ? "is" : "are"] injected."))
	target_mob.reagents.add_reagent(charge.product_type, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return 1

/obj/item/rig_module/chem_dispenser/combat

	name = "combat chemical injector"
	desc = "A complex web of tubing and needles suitable for hardsuit use."

	charges = list(
		list("synaptizine", "synaptizine", /datum/reagent/synaptizine,       30),
		list("hyperzine",   "hyperzine",   /datum/reagent/hyperzine,         30),
		list("oxycodone",   "oxycodone",   /datum/reagent/tramadol/oxycodone,         30),
		list("glucose",     "glucose",     /datum/reagent/nutriment/glucose, 80),
		)

	interface_name = "combat chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."


/obj/item/rig_module/chem_dispenser/injector

	name = "mounted chemical injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	usable = 0
	selectable = 1
	disruptive = 1

	suit_overlay_active = "mounted-injector"

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

/obj/item/rig_module/voice

	name = "hardsuit voice synthesiser"
	desc = "A speaker box and sound processor."
	icon_state = "megaphone"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0
	active_power_cost = 100

	engage_string = "Configure Synthesiser"

	interface_name = "voice synthesiser"
	interface_desc = "A flexible and powerful voice modulator system."

	var/obj/item/voice_changer/voice_holder

/obj/item/rig_module/voice/Initialize()
	. = ..()
	voice_holder = new(src)
	voice_holder.active = 0

/obj/item/rig_module/voice/installed()
	..()
	holder.speech = src
	holder.verbs |= /obj/item/rig/proc/alter_voice

/obj/item/rig_module/voice/removed()
	..()
	holder.speech = null
	holder.verbs -= /obj/item/rig/proc/alter_voice

/obj/item/rig_module/voice/engage()

	if(!..())
		return 0

	var/choice= input("Would you like to toggle the synthesiser or set the name?") as null|anything in list("Enable","Disable","Set Name")

	if(!choice)
		return 0

	switch(choice)
		if("Enable")
			active = 1
			voice_holder.active = 1
			to_chat(usr, SPAN_INFO("You enable the speech synthesiser."))
		if("Disable")
			active = 0
			voice_holder.active = 0
			to_chat(usr, SPAN_INFO("You disable the speech synthesiser."))
		if("Set Name")
			var/raw_choice = sanitize(input(usr, "Please enter a new name.")  as text|null, MAX_NAME_LEN)
			if(!raw_choice)
				return 0
			voice_holder.voice = raw_choice
			to_chat(usr, SPAN_INFO("You are now mimicking <B>[voice_holder.voice]</B>."))
	return 1

/obj/item/rig_module/maneuvering_jets

	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	icon_state = "thrusters"
	usable = 1
	toggleable = 1
	selectable = 0
	disruptive = 0
	active_power_cost = 200

	suit_overlay_active = "maneuvering_active"
	suit_overlay_inactive = null //"maneuvering_inactive"

	engage_string = "Toggle Stabilizers"
	activate_string = "Activate Thrusters"
	deactivate_string = "Deactivate Thrusters"

	interface_name = "maneuvering jets"
	interface_desc = "An inbuilt EVA maneuvering system that runs off the rig air supply."
	origin_tech = list(TECH_MATERIAL = 6,  TECH_ENGINEERING = 7)
	var/obj/item/tank/jetpack/rig/jets

/obj/item/rig_module/maneuvering_jets/engage()
	if(!..())
		return 0
	jets.toggle_rockets()
	return 1

/obj/item/rig_module/maneuvering_jets/activate()

	if(active)
		return 0

	active = 1

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	if(!jets.on)
		jets.toggle()
	return 1

/obj/item/rig_module/maneuvering_jets/deactivate()
	if(!..())
		return 0
	if(jets.on)
		jets.toggle()
	return 1

/obj/item/rig_module/maneuvering_jets/Initialize()
	. = ..()
	jets = new(src)

/obj/item/rig_module/maneuvering_jets/installed()
	..()
	jets.holder = holder
	jets.ion_trail.set_up(holder)

/obj/item/rig_module/maneuvering_jets/removed()
	..()
	jets.holder = null
	jets.ion_trail.set_up(jets)

/obj/item/rig_module/device/paperdispenser
	name = "hardsuit paper dispenser"
	desc = "Crisp sheets."
	icon_state = "paper"
	interface_name = "paper dispenser"
	interface_desc = "Dispenses warm, clean, and crisp sheets of paper."
	engage_string = "Dispense"
	use_power_cost = 200
	usable = 1
	selectable = 0
	device = /obj/item/paper_bin

/obj/item/rig_module/device/paperdispenser/engage(atom/target)

	if(!..() || !device)
		return 0

	if(!target)
		device.attack_hand(holder.wearer)
		return 1

/obj/item/rig_module/device/pen
	name = "mounted pen"
	desc = "For exosuit John Hancocks."
	icon_state = "pen"
	interface_name = "mounted pen"
	interface_desc = "Signatures with style(tm)."
	engage_string = "Change color"
	usable = 1
	device = /obj/item/pen/multi

/obj/item/rig_module/device/stamp
	name = "mounted stamp"
	desc = "DENIED."
	icon_state = "stamp"
	interface_name = "mounted stamp"
	interface_desc = "Leave your mark."
	engage_string = "Toggle stamp type"
	usable = 1
	var/stamp
	var/deniedstamp

/obj/item/rig_module/device/stamp/Initialize()
	. = ..()
	stamp = new /obj/item/stamp(src)
	deniedstamp = new /obj/item/stamp/denied(src)
	device = stamp

/obj/item/rig_module/device/stamp/engage(atom/target)
	if(!..() || !device)
		return 0

	if(!target)
		if(device == stamp)
			device = deniedstamp
			to_chat(holder.wearer, SPAN_NOTICE("Switched to denied stamp."))
		else if(device == deniedstamp)
			device = stamp
			to_chat(holder.wearer, SPAN_NOTICE("Switched to rubber stamp."))
		return 1

/obj/item/rig_module/device/decompiler
	name = "mounted matter decompiler"
	desc = "A drone matter decompiler reconfigured for hardsuit use."
	icon_state = "ewar"
	interface_name = "mounted matter decompiler"
	interface_desc = "Eats trash like no one's business."
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	device = /obj/item/matter_decompiler

/obj/item/rig_module/cooling_unit
	name = "mounted cooling unit"
	icon_state = "cooling"
	toggleable = 1
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 5)
	interface_name = "mounted cooling unit"
	interface_desc = "A heat sink with a liquid cooled radiator."
	module_cooldown = 0 SECONDS //no cd because its critical for a life-support module
	var/charge_consumption = 0.5 KILOWATTS
	var/max_cooling = 12
	var/thermostat = T20C

/obj/item/rig_module/cooling_unit/Process()
	if(!active)
		return passive_power_cost

	var/mob/living/carbon/human/H = holder.wearer

	var/temp_adj = min(H.bodytemperature - thermostat, max_cooling) //Actually copies the original CU code

	if (temp_adj < 0.5)
		return passive_power_cost

	H.bodytemperature -= temp_adj
	active_power_cost = round((temp_adj/max_cooling)*charge_consumption)
	return active_power_cost

/obj/item/rig_module/kinetic_module
	name = "gravikinetic module"
	desc = "A point-gravity manipulator module for the hardsuit."
	icon_state = "kinetic"
	selectable = TRUE
	use_power_cost = 20 KILOWATTS

	interface_name = "gravikinetic module"
	interface_desc = "A directed point-gravity manipulator module for lifting and moving things out of reach."
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 6,  TECH_ENGINEERING = 6)

	var/atom/movable/locked
	var/datum/beam = null
	var/max_dist = 4
	var/obj/effect/warp/small/warpeffect = null

/obj/item/rig_module/kinetic_module/proc/beamdestroyed()
	if(beam)
		GLOB.destroyed_event.unregister(beam, src, PROC_REF(beamdestroyed))
		beam = null
	if(locked)
		if(holder.wearer)
			to_chat(holder.wearer, SPAN_NOTICE("Lock on \the [locked] disengaged."))
		endanimation()
		locked = null
	//It's possible beam self destroyed, match active
	if(active)
		deactivate()

/obj/item/rig_module/kinetic_module/proc/endanimation()
	if(locked)
		animate(locked,pixel_y= initial(locked.pixel_y), time = 0)

/obj/item/rig_module/kinetic_module/deactivate()
	. = ..()
	if(beam)
		QDEL_NULL(beam)

/obj/item/rig_module/kinetic_module/engage(atom/target, mob/living/user, inrange, params)
	. = ..()
	if(.)
		if(!locked && (get_dist(holder.wearer, target) <= max_dist))
			var/atom/movable/AM = target
			if(!istype(AM) || AM.anchored || !AM.simulated)
				to_chat(user, SPAN_NOTICE("Unable to lock on [target]."))
				return
			locked = AM
			beam = holder.wearer.Beam(BeamTarget = target, icon_state = "r_beam", maxdistance = max_dist, beam_type = /obj/ebeam/warp)
			GLOB.destroyed_event.register(beam, src, PROC_REF(beamdestroyed))

			animate(target,pixel_y= initial(target.pixel_y) - 2,time=1 SECOND, easing = SINE_EASING, flags = ANIMATION_PARALLEL, loop = -1)
			animate(pixel_y= initial(target.pixel_y) + 2,time=1 SECOND)

			active = TRUE

			to_chat(user, SPAN_NOTICE("Locked on [AM]."))
			return
		else if(target != locked)
			if(locked in view(holder.wearer))
				endanimation() //End animation without waiting for delete, so throw won't be affected
				locked.throw_at(target, 14, 1.5, holder.wearer)
				locked = null
				deactivate()

				holder.cell.use(use_power_cost * CELLRATE)

			else
				deactivate()
