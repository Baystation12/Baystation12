/obj/machinery/suit_cycler

	name = "suit cycler unit"
	desc = "An industrial suit storage unit designed to accommodate and modify all kinds of spacesuits. Its onboard equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	anchored = TRUE
	density = TRUE
	idle_power_usage = 50
	active_power_usage = 200

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "close"

	req_access = list(access_captain, access_bridge)

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair = 1		// If set, the cycler can repair voidsuits.
	var/electrified = 0		// If set, will shock users.

	// Possible modifications to pick between
	var/list/available_modifications = list(
		/decl/item_modifier/space_suit/engineering,
		/decl/item_modifier/space_suit/mining,
		/decl/item_modifier/space_suit/medical,
		/decl/item_modifier/space_suit/security,
		/decl/item_modifier/space_suit/atmos,
		/decl/item_modifier/space_suit/science,
		/decl/item_modifier/space_suit/pilot,
		/decl/item_modifier/space_suit/command
	)

	// Extra modifications to add when emagged, duplicates won't be added
	var/emagged_modifications = list(
		/decl/item_modifier/space_suit/engineering,
		/decl/item_modifier/space_suit/mining,
		/decl/item_modifier/space_suit/medical,
		/decl/item_modifier/space_suit/security,
		/decl/item_modifier/space_suit/atmos,
		/decl/item_modifier/space_suit/science,
		/decl/item_modifier/space_suit/pilot,
		/decl/item_modifier/space_suit/command,
		/decl/item_modifier/space_suit/mercenary/emag
	)

	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

	var/decl/item_modifier/target_modification
	var/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null
	var/obj/item/clothing/shoes/magboots/boots = null

	wires = /datum/wires/suit_storage_unit

/obj/machinery/suit_cycler/Initialize()
	. = ..()
	if(!length(available_modifications) || !length(species))
		crash_with("Invalid setup: [log_info_line(src)]")
		return INITIALIZE_HINT_QDEL

	available_modifications = list_values(decls_repository.get_decls(available_modifications))

	target_modification = available_modifications[1]
	target_species = species[1]
	update_icon()

/obj/machinery/suit_cycler/Destroy()
	DROP_NULL(occupant)
	DROP_NULL(suit)
	DROP_NULL(helmet)
	DROP_NULL(boots)
	return ..()
	
/obj/machinery/suit_cycler/on_update_icon()
	overlays.Cut()
	if(panel_open)
		overlays += ("panel")
	if(is_broken())
		overlays += ("broken")
	else if(irradiating)
		if(radiation_level > 3)
			overlays += ("super")
		else if(occupant)
			overlays += ("uvhuman")
		else
			overlays += ("uv")
	else if(!locked && !active)
		overlays += ("open")
		if(suit)
			overlays += ("suit")
		if(helmet)
			overlays += ("helm")
		if(boots)
			overlays += ("storage")
	else if(occupant)
		overlays += ("human")
	
/obj/machinery/suit_cycler/proc/try_move_inside(mob/living/target, mob/living/user)
	if(!istype(target) || !istype(user) || !target.Adjacent(user) || !user.Adjacent(src) || user.incapacitated())
		return FALSE

	if(locked || active)
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return FALSE

	if(suit || helmet || boots)
		to_chat(user, SPAN_WARNING("There is no room inside \the [src] for \the [target]."))
		return FALSE

	if(target == user)
		visible_message(
			SPAN_NOTICE("\The [user] starts climbing into \the [src]."),
			SPAN_NOTICE("You start climbing into \the [src].")
		)
	else
		visible_message(
			SPAN_NOTICE("\The [user] starts putting \the [target] into \the [src]."),
			SPAN_NOTICE("You start putting \the [target] into \the [src].")
		)
	
	if(do_after(user, 2 SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		if(!istype(target) || locked || active || suit || helmet || boots || !target.Adjacent(user) || !user.Adjacent(src) || user.incapacitated())
			return FALSE
		target.reset_view(src)
		target.forceMove(src)
		occupant = target
		add_fingerprint(user)
		update_icon()
		return TRUE
	return FALSE

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(isMultitool(I) || isWirecutter(I))
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(try_move_inside(G.affecting, user))
			qdel(G)
			updateUsrDialog()
			return

	else if(isScrewdriver(I))

		panel_open = !panel_open
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, "You [panel_open ?  "open" : "close"] \the [src]'s maintenance panel.")
		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))

		if(locked || active)
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return

		if(helmet)
			to_chat(user, SPAN_WARNING("\The [src] already contains a helmet."))
			return

		if(!user.unEquip(I, src))
			return
		to_chat(user, SPAN_NOTICE("You fit \the [I] into \the [src]."))
		helmet = I
		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/suit/space/void))

		if(locked || active)
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return

		if(suit)
			to_chat(user, SPAN_WARNING("\The [src] already contains a voidsuit."))
			return

		if(!user.unEquip(I, src))
			return
		to_chat(user, SPAN_NOTICE("You fit \the [I] into \the [src]."))
		suit = I
		update_icon()
		updateUsrDialog()
		return
	else if(istype(I, /obj/item/clothing/shoes/magboots))

		if(locked || active)
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return

		if(boots)
			to_chat(user, SPAN_WARNING("\The [src] already contains some boots."))
			return

		if(!user.unEquip(I, src))
			return
		to_chat(user, SPAN_NOTICE("You fit \the [I] into \the [src]."))
		boots = I
		update_icon()
		updateUsrDialog()
		return

	..()
	
/obj/machinery/suit_cycler/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	try_move_inside(target, user)
	
/obj/machinery/suit_cycler/relaymove(var/mob/user)
	..()
	eject_occupant()
	
/obj/machinery/suit_cycler/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src] has already been subverted."))
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, SPAN_DANGER("You run the sequencer across \the [src]'s interface, corrupting the operating protocols."))

	var/additional_modifications = list_values(decls_repository.get_decls(emagged_modifications))
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
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(allowed(user))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>\[eject\]</a>"
		dat += "<b>Boots: </b> [boots ? "\the [boots]" : "no boots stored" ]. <A href='?src=\ref[src];eject_boots=1'>Eject</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_modification.name]</a>, <A href='?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<A href='?src=\ref[src];apply_paintjob=1'><br>\[apply customisation routine\]</a><br><hr>"

	show_browser(user, JOINTEXT(dat), "window=suit_cycler")
	onclose(user, "suit_cycler")
	return
	
/obj/machinery/suit_cycler/CanUseTopic(user)
	if(user == occupant)
		to_chat(usr, SPAN_WARNING("You can't reach the controls from the inside."))
		return STATUS_CLOSE
	. = ..()

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
	else if(href_list["eject_boots"])
		if(!boots) return
		boots.dropInto(loc)
		boots = null
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
		update_use_power(POWER_USE_ACTIVE)
		playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)
		active = 1
		update_icon()
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])

		if(!suit && !helmet) return
		update_use_power(POWER_USE_ACTIVE)
		playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)
		active = 1
		update_icon()
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])

		if(allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "lock" : "unlock"] [src].")
			playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)
			update_icon()
		else
			to_chat(usr, FEEDBACK_ACCESS_DENIED)

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			to_chat(usr, SPAN_DANGER("\The [src] has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
			return

		update_use_power(POWER_USE_ACTIVE)
		playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)
		active = 1
		irradiating = 10
		update_icon()
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

	if(active && stat & (BROKEN|NOPOWER))
		update_use_power(POWER_USE_IDLE)
		active = 0
		irradiating = 0
		electrified = 0
		update_icon()
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		update_icon()
		return

	if(irradiating > 1)
		irradiating--

	update_icon()

	if(occupant)
		if(prob(radiation_level*2) && occupant.can_feel_pain()) 
			occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0,radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0,radiation_level + rand(1,3))
		occupant.apply_damage(radiation_level*10, IRRADIATE, damage_flags = DAM_DISPERSED)

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_NOTICE("\The [src] pings loudly."))
	playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)
	update_use_power(POWER_USE_IDLE)
	active = 0
	updateUsrDialog()
	update_icon()

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
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return

	if (!occupant)
		return

	occupant.reset_view()
	occupant.dropInto(loc)
	occupant = null

	update_icon()
	add_fingerprint(user)
	updateUsrDialog()

	return

/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_species || !target_modification)
		return

	if(helmet) helmet.refit_for_species(target_species)
	if(suit) suit.refit_for_species(target_species)
	if(boots)  boots.refit_for_species(target_species)

	target_modification.RefitItem(helmet)
	target_modification.RefitItem(suit)
	target_modification.RefitItem(boots)

	if(helmet) helmet.SetName("refitted [helmet.name]")
	if(suit) suit.SetName("refitted [suit.name]")
	if(boots)  boots.SetName("refitted [initial(boots.name)]")
