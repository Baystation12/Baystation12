// GENERIC PRINTER - DO NOT USE THIS OBJECT.
// Flesh and robot printers are defined below this object.

/obj/machinery/organ_printer
	name = "organ printer"
	desc = "It's a machine that prints organs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"

	anchored = TRUE
	density = TRUE
	idle_power_usage = 40
	active_power_usage = 300
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/stored_matter = 0
	var/max_stored_matter = 0
	var/print_delay = 100
	var/printing

	// These should be subtypes of /obj/item/organ
	var/list/products = list()

/obj/machinery/organ_printer/state_transition(singleton/machine_construction/default/new_state)
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
	to_chat(user, SPAN_NOTICE("It is loaded with [stored_matter]/[max_stored_matter] matter units."))

/obj/machinery/organ_printer/RefreshParts()
	print_delay = initial(print_delay)
	print_delay -= 10 * total_component_rating_of_type(/obj/item/stock_parts/manipulator)
	print_delay += 10 * number_of_components(/obj/item/stock_parts/manipulator)
	print_delay = max(0, print_delay)

	max_stored_matter = 50 * clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 20)
	. = ..()

/obj/machinery/organ_printer/components_are_accessible(path)
	return !printing && ..()

/obj/machinery/organ_printer/cannot_transition_to(path)
	if(printing)
		return SPAN_NOTICE("You must wait for \the [src] to finish printing first!")
	return ..()

/obj/machinery/organ_printer/physical_attack_hand(mob/user, choice = null)
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

	if(!choice || !src || inoperable())
		return TRUE

	print_organ(choice)

/obj/machinery/organ_printer/proc/can_print(choice)
	if(stored_matter < products[choice][2])
		visible_message(SPAN_NOTICE("\The [src] displays a warning: 'Not enough matter. [stored_matter] stored and [products[choice][2]] needed.'"))
		return 0
	return 1

/obj/machinery/organ_printer/proc/print_organ(choice)
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
		BP_GROIN    = list(/obj/item/organ/external/groin,      75),
		BP_CELL		= list(/obj/item/organ/internal/cell, 25)
		)

	machine_name = "prosthetic organ fabricator"
	machine_desc = "Creates prosthetic limbs and organs by using steel sheets."
	var/matter_amount_per_sheet = 10
	var/matter_type = MATERIAL_STEEL

/obj/machinery/organ_printer/robot/mapped/Initialize()
	. = ..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/robot/dismantle()
	if(stored_matter >= matter_amount_per_sheet)
		new /obj/item/stack/material/steel(get_turf(src), Floor(stored_matter/matter_amount_per_sheet))
	return ..()

/obj/machinery/organ_printer/robot/print_organ(choice)
	var/obj/item/organ/O = ..()
	O.robotize()
	O.status |= ORGAN_CUT_AWAY  // robotize() resets status to 0
	visible_message(SPAN_INFO("\The [src] churns for a moment, then spits out \a [O]."))
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return O


/obj/machinery/organ_printer/robot/use_tool(obj/item/tool, mob/user, list/click_params)
	/// Integer. Amount of storage space left for matter. Used by the various interactions that refill the printer.
	var/space_left = max_stored_matter - stored_matter

	// Material Stack - Add material
	if (istype(tool, /obj/item/stack/material))
		var/obj/item/stack/material/material_stack = tool
		var/material_stack_name = material_stack.get_material_name()
		if (material_stack_name != matter_type)
			to_chat(user, SPAN_WARNING("\The [src] does not accept [material_stack_name]. It only accepts [matter_type]."))
			return TRUE
		if (space_left < matter_amount_per_sheet)
			to_chat(user, SPAN_WARNING("\The [src] is too full to be refilled with \the [tool]."))
			return TRUE
		var/sheets_to_take = min(material_stack.amount, Floor(space_left / matter_amount_per_sheet))
		stored_matter += sheets_to_take * matter_amount_per_sheet
		material_stack.use(sheets_to_take)
		user.visible_message(
			SPAN_NOTICE("\The [user] refills \the [src] with some [material_stack.plural_name] of [material_stack_name]."),
			SPAN_NOTICE("You refill \the [src] with [sheets_to_take] [sheets_to_take == 1 ? material_stack.singular_name : material_stack.plural_name] of [material_stack_name].")
		)
		to_chat(user, SPAN_NOTICE("\The [src] now has [stored_matter] units of matter stored."))
		return TRUE

	// Organs - Add material
	if (istype(tool, /obj/item/organ))
		var/obj/item/organ/organ = tool
		if (!(organ.organ_tag in products) || !istype(organ, products[organ.organ_tag][1]))
			to_chat(user, SPAN_WARNING("\The [src] cannot recyle \the [tool]. It can only recycle organs it can print."))
			return TRUE
		if (!BP_IS_ROBOTIC(organ))
			to_chat(user, SPAN_WARNING("\The [src] cannot recyle \the [tool]. It can only recycle robotic organs."))
			return TRUE
		var/recycle_worth = Floor(products[organ.organ_tag][2] * 0.5)
		if (space_left < recycle_worth)
			to_chat(user, SPAN_WARNING("\The [src] is too full to be refilled with \the [tool]."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [src]."))
			return TRUE
		stored_matter += recycle_worth
		user.visible_message(
			SPAN_NOTICE("\The [user] recycles \a [tool] into \the [src]."),
			SPAN_NOTICE("You recycle \the [tool] into \the [src].")
		)
		qdel(tool)
		to_chat(user, SPAN_NOTICE("\The [src] now has [stored_matter] units of matter stored."))
		return TRUE

	return ..()


// FLESH ORGAN PRINTER
/obj/machinery/organ_printer/flesh
	name = "bioprinter"
	desc = "It's a machine that prints replacement organs."
	icon_state = "bioprinter"
	base_type = /obj/machinery/organ_printer/flesh
	machine_name = "bioprinter"
	machine_desc = "Bioprinters can create surrogate organs for many species by using a blood sample from the intended recipient. Uses meat for biological matter."
	// null amount means it will calculate the cost based on get_organ_cost()
	var/list/amount_list = list(
		/obj/item/reagent_containers/food/snacks/meat = 50,
		/obj/item/reagent_containers/food/snacks/rawcutlet = 15,
		/obj/item/organ = null
		)
	var/datum/dna/loaded_dna_datum
	var/datum/species/loaded_species //For quick refrencing

/obj/machinery/organ_printer/flesh/mapped/Initialize()
	. = ..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/flesh/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		while(stored_matter >= amount_list[/obj/item/reagent_containers/food/snacks/meat])
			stored_matter -= amount_list[/obj/item/reagent_containers/food/snacks/meat]
			new /obj/item/reagent_containers/food/snacks/meat(T)
	return ..()

/obj/machinery/organ_printer/flesh/print_organ(choice)
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
	visible_message(SPAN_INFO("\The [src] churns for a moment, injects its stored DNA into the biomass, then spits out \a [O]."))
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return O

/obj/machinery/organ_printer/flesh/physical_attack_hand(mob/user)
	if(!loaded_dna_datum || !loaded_species)
		visible_message(SPAN_INFO("\The [src] displays a warning: 'No DNA saved. Insert a blood sample.'"))
		return

	var/choice = input("What [loaded_species.name] organ would you like to print?") as null|anything in products

	if(!choice)
		return

	..(user, choice)


/obj/machinery/organ_printer/flesh/use_tool(obj/item/tool, mob/user, list/click_params)
	// Syringe - Inject DNA sample
	if (istype(tool, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/syringe = tool
		var/datum/reagent/blood/injected = syringe.reagents.get_reagent(/datum/reagent/blood)
		if (!injected)
			to_chat(user, SPAN_WARNING("\The [tool] has no blood in it."))
			return TRUE
		if (!LAZYLEN(injected.data))
			to_chat(user, SPAN_WARNING("The blood sample in \the [tool] has no DNA."))
			return TRUE
		var/weakref/weakref = injected.data["donor"]
		var/mob/living/carbon/human/donor = weakref.resolve()
		if (!istype(donor) || !donor.species || !donor.dna)
			to_chat(user, SPAN_WARNING("The blood sample in \the [tool] is too old."))
			return TRUE
		loaded_species = donor.species
		loaded_dna_datum = donor.dna.Clone()
		products = get_possible_products()
		user.visible_message(
			SPAN_NOTICE("\The [user] injects a blood sample into \the [src] with \a [tool]."),
			SPAN_NOTICE("You inject a blood sample into \the [src] with \the [tool].")
		)
		return TRUE

	// Everything Else - Load with matter
	var/type_match
	for (var/path in amount_list)
		if (istype(tool, path))
			type_match = path
			break
	if (type_match)
		if (max_stored_matter == stored_matter)
			to_chat(user, SPAN_WARNING("\The [src] is too full to be refilled with \the [tool]."))
			return TRUE
		if (!user.unEquip(tool))
			to_chat(user, SPAN_WARNING("You can't drop \the [src]."))
			return TRUE
		var/add_matter = amount_list[type_match] ? amount_list[type_match] : round(0.5 * get_organ_cost(tool))
		stored_matter = min(stored_matter + add_matter, max_stored_matter)
		user.visible_message(
			SPAN_NOTICE("\The [user] refills \the [src] with \a [tool]."),
			SPAN_NOTICE("You refill \the [src] with \the [tool].")
		)
		qdel(tool)
		to_chat(user, SPAN_NOTICE("\The [src] now has [stored_matter] units of matter stored."))
		return TRUE

	return ..()


/obj/machinery/organ_printer/flesh/proc/get_possible_products()
	. = list()
	if(!loaded_species)
		return
	var/list/organs = list()
	for(var/organ in loaded_species.has_organ)
		organs += loaded_species.has_organ[organ]
	for(var/organ in loaded_species.has_limbs)
		if ((loaded_species.name == SPECIES_NABBER) || (organ == BP_GROIN))
			organs += loaded_species.has_limbs[organ]["path"]
	for(var/organ in organs)
		var/obj/item/organ/O = organ
		if(check_printable(organ))
			.[initial(O.organ_tag)] = list(O, get_organ_cost(O))

/obj/machinery/organ_printer/flesh/proc/get_organ_cost(obj/item/organ/O)
	. = initial(O.print_cost)
	if(!.)
		. = round(0.75 * initial(O.max_damage))

/obj/machinery/organ_printer/flesh/proc/check_printable(organtype)
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
