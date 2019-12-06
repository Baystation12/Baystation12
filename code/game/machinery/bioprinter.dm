// GENERIC PRINTER - DO NOT USE THIS OBJECT.
// Flesh and robot printers are defined below this object.

/obj/machinery/organ_printer
	name = "organ printer"
	desc = "It's a machine that prints organs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"

	anchored = 1
	density = 1
	idle_power_usage = 40
	active_power_usage = 300
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/stored_matter = 0
	var/max_stored_matter = 0
	var/print_delay = 100
	var/printing

	// These should be subtypes of /obj/item/organ
	var/list/products = list()

/obj/machinery/organ_printer/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/organ_printer/on_update_icon()
	overlays.Cut()
	if(panel_open)
		overlays += "[icon_state]_panel_open"
	if(printing)
		overlays += "[icon_state]_working"

/obj/machinery/organ_printer/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>It is loaded with [stored_matter]/[max_stored_matter] matter units.</span>")

/obj/machinery/organ_printer/RefreshParts()
	print_delay = initial(print_delay)
	print_delay -= 10 * total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator)
	print_delay += 10 * number_of_components(/obj/item/weapon/stock_parts/manipulator)
	print_delay = max(0, print_delay)

	max_stored_matter = 50 * Clamp(total_component_rating_of_type(/obj/item/weapon/stock_parts/matter_bin), 0, 20)
	. = ..()

/obj/machinery/organ_printer/components_are_accessible(path)
	return !printing && ..()

/obj/machinery/organ_printer/cannot_transition_to(path)
	if(printing)
		return SPAN_NOTICE("You must wait for \the [src] to finish printing first!")
	return ..()

/obj/machinery/organ_printer/physical_attack_hand(mob/user, var/choice = null)
	if(printing)
		return

	if(!choice)
		choice = input("What would you like to print?") as null|anything in products

	if(!choice || printing || !CanPhysicallyInteract(user))
		return TRUE

	if(!can_print(choice))
		return TRUE

	stored_matter -= products[choice][2]

	update_use_power(POWER_USE_ACTIVE)
	printing = 1
	update_icon()

	sleep(print_delay)

	update_use_power(POWER_USE_IDLE)
	printing = 0
	update_icon()

	if(!choice || !src || (stat & (BROKEN|NOPOWER)))
		return TRUE

	print_organ(choice)

/obj/machinery/organ_printer/proc/can_print(var/choice)
	if(stored_matter < products[choice][2])
		visible_message("<span class='notice'>\The [src] displays a warning: 'Not enough matter. [stored_matter] stored and [products[choice][2]] needed.'</span>")
		return 0
	return 1

/obj/machinery/organ_printer/proc/print_organ(var/choice)
	var/new_organ = products[choice][1]
	var/obj/item/organ/O = new new_organ(get_turf(src))
	O.status |= ORGAN_CUT_AWAY
	return O
// END GENERIC PRINTER

// ROBOT ORGAN PRINTER
/obj/machinery/organ_printer/robot
	name = "prosthetic organ fabricator"
	desc = "It's a machine that prints prosthetic organs."
	icon_state = "roboprinter"
	base_type = /obj/machinery/organ_printer/robot

	products = list(
		BP_HEART    = list(/obj/item/organ/internal/heart,      25),
		BP_LUNGS    = list(/obj/item/organ/internal/lungs,      25),
		BP_KIDNEYS  = list(/obj/item/organ/internal/kidneys,    20),
		BP_EYES     = list(/obj/item/organ/internal/eyes,       20),
		BP_LIVER    = list(/obj/item/organ/internal/liver,      25),
		BP_STOMACH  = list(/obj/item/organ/internal/stomach,    25),
		BP_L_ARM    = list(/obj/item/organ/external/arm,        65),
		BP_R_ARM    = list(/obj/item/organ/external/arm/right,  65),
		BP_L_LEG    = list(/obj/item/organ/external/leg,        65),
		BP_R_LEG    = list(/obj/item/organ/external/leg/right,  65),
		BP_L_FOOT   = list(/obj/item/organ/external/foot,       40),
		BP_R_FOOT   = list(/obj/item/organ/external/foot/right, 40),
		BP_L_HAND   = list(/obj/item/organ/external/hand,       40),
		BP_R_HAND   = list(/obj/item/organ/external/hand/right, 40),
		BP_CELL		= list(/obj/item/organ/internal/cell, 25)
		)

	var/matter_amount_per_sheet = 10
	var/matter_type = MATERIAL_STEEL

/obj/machinery/organ_printer/robot/mapped/Initialize()
	. = ..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/robot/dismantle()
	if(stored_matter >= matter_amount_per_sheet)
		new /obj/item/stack/material/steel(get_turf(src), Floor(stored_matter/matter_amount_per_sheet))
	return ..()

/obj/machinery/organ_printer/robot/print_organ(var/choice)
	var/obj/item/organ/O = ..()
	O.robotize()
	O.status |= ORGAN_CUT_AWAY  // robotize() resets status to 0
	visible_message("<span class='info'>\The [src] churns for a moment, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/robot/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == matter_type)
		if((max_stored_matter-stored_matter) < matter_amount_per_sheet)
			to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
			return
		var/obj/item/stack/S = W
		var/space_left = max_stored_matter - stored_matter
		var/sheets_to_take = min(S.amount, Floor(space_left/matter_amount_per_sheet))
		if(sheets_to_take <= 0)
			to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
			return
		stored_matter = min(max_stored_matter, stored_matter + (sheets_to_take*matter_amount_per_sheet))
		to_chat(user, "<span class='info'>\The [src] processes \the [W]. Levels of stored matter now: [stored_matter]</span>")
		S.use(sheets_to_take)
		return
	return ..()
// END ROBOT ORGAN PRINTER

// FLESH ORGAN PRINTER
/obj/machinery/organ_printer/flesh
	name = "bioprinter"
	desc = "It's a machine that prints replacement organs."
	icon_state = "bioprinter"
	base_type = /obj/machinery/organ_printer/flesh
	var/list/amount_list = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat = 50,
		/obj/item/weapon/reagent_containers/food/snacks/rawcutlet = 15
		)
	var/datum/dna/loaded_dna_datum
	var/datum/species/loaded_species //For quick refrencing

/obj/machinery/organ_printer/flesh/mapped/Initialize()
	. = ..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/flesh/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		while(stored_matter >= amount_list[/obj/item/weapon/reagent_containers/food/snacks/meat])
			stored_matter -= amount_list[/obj/item/weapon/reagent_containers/food/snacks/meat]
			new /obj/item/weapon/reagent_containers/food/snacks/meat(T)
	return ..()

/obj/machinery/organ_printer/flesh/print_organ(var/choice)
	var/obj/item/organ/O
	var/new_organ
	if(loaded_species.has_organ[choice])
		new_organ = loaded_species.has_organ[choice]
	else if(loaded_species.has_limbs[choice])
		new_organ = loaded_species.has_limbs[choice]["path"]
	if(new_organ)
		O = new new_organ(get_turf(src), loaded_dna_datum)
		O.status |= ORGAN_CUT_AWAY
	else
		O = ..()
	if(O.species)
		// This is a very hacky way of doing of what organ/New() does if it has an owner
		O.w_class = max(O.w_class + mob_size_difference(O.species.mob_size, MOB_MEDIUM), 1)

	visible_message("<span class='info'>\The [src] churns for a moment, injects its stored DNA into the biomass, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/flesh/physical_attack_hand(mob/user)
	if(!loaded_dna_datum || !loaded_species)
		visible_message("<span class='info'>\The [src] displays a warning: 'No DNA saved. Insert a blood sample.'</span>")
		return

	var/choice = input("What [loaded_species.name] organ would you like to print?") as null|anything in products

	if(!choice)
		return

	..(user, choice)

/obj/machinery/organ_printer/flesh/attackby(obj/item/weapon/W, mob/user)
	// Load with matter for printing.
	for(var/path in amount_list)
		if(istype(W, path))
			if(max_stored_matter == stored_matter)
				to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
				return
			if(!user.unEquip(W))
				return
			stored_matter += min(amount_list[path], max_stored_matter - stored_matter)
			to_chat(user, "<span class='info'>\The [src] processes \the [W]. Levels of stored biomass now: [stored_matter]</span>")
			qdel(W)

	// DNA sample from syringe.
	if(istype(W,/obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && LAZYLEN(injected.data))
			var/loaded_dna = injected.data
			var/weakref/R = loaded_dna["donor"]
			var/mob/living/carbon/human/H = R.resolve()
			if(H && istype(H) && H.species && H.dna)
				loaded_species = H.species
				loaded_dna_datum = H.dna && H.dna.Clone()
				products = get_possible_products()
				to_chat(user, "<span class='info'>You inject the blood sample into the bioprinter.</span>")
				return TRUE
		to_chat(user, SPAN_NOTICE("\The [src] displays an error: no viable blood sample could be obtained from \the [W]."))
	return ..()

/obj/machinery/organ_printer/flesh/proc/get_possible_products()
	. = list()
	if(!loaded_species)
		return
	var/list/organs = list()
	for(var/organ in loaded_species.has_organ)
		organs += loaded_species.has_organ[organ]
	for(var/organ in loaded_species.has_limbs)
		organs += loaded_species.has_limbs[organ]["path"]
	for(var/organ in organs)
		var/obj/item/organ/O = organ
		if(check_printable(organ))
			var/cost = initial(O.print_cost)
			if(!cost)
				cost = round(0.75 * initial(O.max_damage))
			.[initial(O.organ_tag)] = list(O, cost)

/obj/machinery/organ_printer/flesh/proc/check_printable(var/organtype)
	var/obj/item/organ/O = organtype
	if(!initial(O.can_be_printed))
		return FALSE
	if(initial(O.vital))
		return FALSE
	if(initial(O.status) & ORGAN_ROBOTIC)
		return FALSE
	if(ispath(organtype, /obj/item/organ/external))
		var/obj/item/organ/external/E = organtype
		if(initial(E.limb_flags) & ORGAN_FLAG_HEALS_OVERKILL)
			return FALSE
	return TRUE

// END FLESH ORGAN PRINTER
