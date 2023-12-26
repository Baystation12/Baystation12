/obj/machinery/suit_cycler

	name = "suit cycler unit"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = TRUE
	density = TRUE

	icon = 'icons/obj/machines/suitstorage.dmi'
	icon_state = "close"

	req_access = list(access_captain, access_bridge)

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair = 1         // If set, the cycler can repair voidsuits.
	var/electrified = 0

	// Possible modifications to pick between
	var/list/available_modifications = list(
		/singleton/item_modifier/space_suit/atmos,
		/singleton/item_modifier/space_suit/engineering,
		/singleton/item_modifier/space_suit/medical,
		/singleton/item_modifier/space_suit/mining,
		/singleton/item_modifier/space_suit/pilot,
		/singleton/item_modifier/space_suit/science,
		/singleton/item_modifier/space_suit/security
	)

	// Extra modifications to add when emagged, duplicates won't be added
	var/emagged_modifications = list(
		/singleton/item_modifier/space_suit/atmos,
		/singleton/item_modifier/space_suit/engineering,
		/singleton/item_modifier/space_suit/medical,
		/singleton/item_modifier/space_suit/mining,
		/singleton/item_modifier/space_suit/pilot,
		/singleton/item_modifier/space_suit/science,
		/singleton/item_modifier/space_suit/security,
		/singleton/item_modifier/space_suit/mercenary/emag
	)

	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

	var/singleton/item_modifier/target_modification
	var/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

	wires = /datum/wires/suit_storage_unit

/obj/machinery/suit_cycler/Initialize()
	. = ..()
	if(!length(available_modifications) || !length(species))
		crash_with("Invalid setup: [log_info_line(src)]")
		return INITIALIZE_HINT_QDEL

	available_modifications = list_values(Singletons.GetMap(available_modifications))

	target_modification = available_modifications[1]
	target_species = species[1]

/obj/machinery/suit_cycler/Destroy()
	DROP_NULL(occupant)
	DROP_NULL(suit)
	DROP_NULL(helmet)
	return ..()

/obj/machinery/suit_cycler/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(electrified != 0)
		if(shock(user, 100))
			return TRUE

	//Hacking init.
	if(isMultitool(I) || isWirecutter(I))
		if(panel_open)
			attack_hand(user)
		return TRUE
	//Other interface stuff.
	if (isScrewdriver(I))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		updateUsrDialog()
		return TRUE

	if (istype(I,/obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))
		if(locked)
			to_chat(user, SPAN_DANGER("The suit cycler is locked."))
			return TRUE

		if(helmet)
			to_chat(user, SPAN_DANGER("The cycler already contains a helmet."))
			return TRUE

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return TRUE
		if(!user.unEquip(I, src))
			return TRUE
		to_chat(user, "You fit \the [I] into the suit cycler.")
		helmet = I
		updateUsrDialog()
		return TRUE

	if (istype(I,/obj/item/clothing/suit/space/void))
		if(locked)
			to_chat(user, SPAN_DANGER("The suit cycler is locked."))
			return TRUE

		if(suit)
			to_chat(user, SPAN_DANGER("The cycler already contains a voidsuit."))
			return TRUE

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return TRUE
		if(!user.unEquip(I, src))
			return TRUE
		to_chat(user, "You fit \the [I] into the suit cycler.")
		suit = I
		updateUsrDialog()
		return TRUE

	return ..()

/obj/machinery/suit_cycler/proc/move_target_inside(mob/target, mob/user)
	visible_message(SPAN_NOTICE("\The [user] starts putting \the [target] into \the [src]."), range = 3)
	add_fingerprint(user)
	if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
		if (!user_can_move_target_inside(target, user))
			return
		if (target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		target.forceMove(src)
		occupant = target
		if (user != target)
			add_fingerprint (target)
		target.remove_grabs_and_pulls()
		updateUsrDialog()

/obj/machinery/suit_cycler/user_can_move_target_inside(mob/target, mob/user)
	if (locked)
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return FALSE
	if (suit || helmet || occupant)
		to_chat(user, SPAN_WARNING("There is no room inside \the [src] for \the [target]."))
		return FALSE
	return ..()

/obj/machinery/suit_cycler/use_grab(obj/item/grab/grab, list/click_params)
	if (!user_can_move_target_inside(grab.affecting, grab.assailant))
		return TRUE
	move_target_inside(grab.affecting, grab.assailant)
	return TRUE

/obj/machinery/suit_cycler/MouseDrop_T(mob/target, mob/user)
	if (!ismob(target) || !CanMouseDrop(target, user))
		return
	if (user != target)
		to_chat(user, SPAN_WARNING("You need to grab \the [target] to be able to do that!"))
		return
	else if (user_can_move_target_inside(target, user))
		move_target_inside(target, user)
		return

/obj/machinery/suit_cycler/emag_act(remaining_charges, mob/user)
	if(emagged)
		to_chat(user, SPAN_DANGER("The cycler has already been subverted."))
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, SPAN_DANGER("You run the sequencer across the interface, corrupting the operating protocols."))

	var/additional_modifications = list_values(Singletons.GetMap(emagged_modifications))
	available_modifications |= additional_modifications

	emagged = TRUE
	safeties = 0
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/physical_attack_hand(mob/user)
	if(electrified != 0)
		if(shock(user, 100))
			return TRUE

/obj/machinery/suit_cycler/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/suit_cycler/interact(mob/user)
	user.set_machine(src)

	var/dat = list()
	dat += "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(active)
		dat+= "<br>[SPAN_COLOR("red", "<b>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b>")]"

	else if(locked)
		dat += "<br>[SPAN_COLOR("red", "<b>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b>")]"
		if(allowed(user))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>\[eject\]</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> [emagged ? SPAN_COLOR("red", "SYSTEM ERROR") : SPAN_COLOR("green", "READY")]<br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_modification.name]</a>, <A href='?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<A href='?src=\ref[src];apply_paintjob=1'><br>\[apply customisation routine\]</a><br><hr>"

	show_browser(user, JOINTEXT(dat), "window=suit_cycler")
	onclose(user, "suit_cycler")
	return

/obj/machinery/suit_cycler/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["eject_suit"])
		if(!suit) return
		suit.dropInto(loc)
		suit = null
	else if(href_list["eject_helmet"])
		if(!helmet) return
		helmet.dropInto(loc)
		helmet = null
	else if(href_list["select_department"])
		var/choice = input("Please select the target department paintjob.", "Suit cycler", target_modification) as null|anything in available_modifications
		if(choice && CanPhysicallyInteract(usr))
			target_modification = choice
	else if(href_list["select_species"])
		var/choice = input("Please select the target species configuration.","Suit cycler",null) as null|anything in species
		if(choice && CanPhysicallyInteract(usr))
			target_species = choice
	else if(href_list["select_rad_level"])
		var/choices = list(1,2,3)
		if(emagged)
			choices = list(1,2,3,4,5)
		radiation_level = input("Please select the desired radiation level.","Suit cycler",null) as null|anything in choices
	else if(href_list["repair_suit"])

		if(!suit || !can_repair) return
		active = 1
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])

		if(!suit && !helmet) return
		active = 1
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])

		if(allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "lock" : "unlock"] [src].")
		else
			FEEDBACK_ACCESS_DENIED(usr, src)

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			to_chat(usr, SPAN_DANGER("The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
			return

		active = 1
		irradiating = 10
		updateUsrDialog()

		sleep(10)

		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

	updateUsrDialog()

/obj/machinery/suit_cycler/Process()
	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && inoperable())
		active = 0
		irradiating = 0
		electrified = 0
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		return

	irradiating--

	if(occupant)
		if(prob(radiation_level*2)) occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0,radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0,radiation_level + rand(1,3))
		occupant.apply_damage(radiation_level*10, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message("[icon2html(src, viewers(get_turf(src)))][SPAN_NOTICE("\The [src] pings loudly.")]")
	active = 0
	updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)

	if (usr.incapacitated())
		return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user as mob)

	if(locked || active)
		to_chat(user, SPAN_WARNING("The cycler is locked."))
		return

	if (!occupant)
		return

	occupant.reset_view()
	occupant.dropInto(loc)
	occupant = null

	add_fingerprint(user)
	updateUsrDialog()

	return

/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_species || !target_modification)
		return

	target_modification.RefitItem(helmet)
	target_modification.RefitItem(suit)

	if(helmet) helmet.refit_for_species(target_species)
	if(suit) suit.refit_for_species(target_species)

	if(helmet) helmet.SetName("refitted [helmet.name]")
	if(suit) suit.SetName("refitted [suit.name]")
