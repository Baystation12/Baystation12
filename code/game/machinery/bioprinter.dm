// GENERIC PRINTER - DO NOT USE THIS OBJECT.
// Flesh and robot printers are defined below this object.

/obj/machinery/organ_printer
	name = "organ printer"
	desc = "It's a machine that prints organs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 40
	active_power_usage = 300

	var/stored_matter = 0
	var/max_stored_matter = 0
	var/print_delay = 100
	var/printing

	var/list/products = list(
		"heart" =   list(/obj/item/organ/heart,  50),
		"lungs" =   list(/obj/item/organ/lungs,  40),
		"kidneys" = list(/obj/item/organ/kidneys,20),
		"eyes" =    list(/obj/item/organ/eyes,   30),
		"liver" =   list(/obj/item/organ/liver,  50)
		)

/obj/machinery/organ_printer/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	return ..()

/obj/machinery/organ_printer/update_icon()
	overlays.Cut()
	if(panel_open)
		overlays += "bioprinter_panel_open"
	if(printing)
		overlays += "bioprinter_working"

/obj/machinery/organ_printer/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	RefreshParts()

/obj/machinery/organ_printer/examine(var/mob/user)
	..()
	user << "<span class='notice'>It is loaded with [stored_matter]/[max_stored_matter] matter units.</span>"

/obj/machinery/organ_printer/RefreshParts()
	print_delay = initial(print_delay)
	max_stored_matter = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/bin in component_parts)
		max_stored_matter += bin.rating * 50
	for(var/obj/item/weapon/stock_parts/manipulator/manip in component_parts)
		print_delay -= (manip.rating-1)*10
	print_delay = max(0,print_delay)
	. = ..()

/obj/machinery/organ_printer/attack_hand(mob/user)

	if(printing || (stat & (BROKEN|NOPOWER)))
		return

	var/choice = input("What would you like to print?") as null|anything in products

	if(!choice || printing || (stat & (BROKEN|NOPOWER)))
		return

	if(stored_matter <= products[choice][2])
		user << "<span class='warning'>There is not enough matter in \the [src].</span>"
		return

	stored_matter -= products[choice][2]

	use_power = 2
	printing = 1
	update_icon()

	sleep(print_delay)

	use_power = 1
	printing = 0
	update_icon()

	if(!choice || !src || (stat & (BROKEN|NOPOWER)))
		return

	print_organ(choice)

/obj/machinery/organ_printer/proc/print_organ(var/choice)
	var/new_organ = products[choice][1]
	var/obj/item/result = new new_organ(get_turf(src))
	return result
// END GENERIC PRINTER

// ROBOT ORGAN PRINTER
/obj/machinery/organ_printer/robot
	name = "prosthetic organ fabricator"
	desc = "It's a machine that prints prosthetic organs."
	icon_state = "roboprinter"

	var/matter_amount_per_sheet = 10
	var/matter_type = DEFAULT_WALL_MATERIAL

/obj/machinery/organ_printer/robot/mapped/initialize()
	..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/robot/dismantle()
	if(stored_matter >= matter_amount_per_sheet)
		new /obj/item/stack/material/steel(get_turf(src), Floor(stored_matter/matter_amount_per_sheet))
	return ..()

/obj/machinery/organ_printer/robot/New()
	..()
	component_parts += new /obj/item/weapon/circuitboard/roboprinter

/obj/machinery/organ_printer/robot/print_organ(var/choice)
	var/obj/item/organ/O = ..()
	O.robotize()
	visible_message("<span class='info'>\The [src] churns for a moment, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/robot/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == matter_type)
		if((max_stored_matter-stored_matter) < matter_amount_per_sheet)
			user << "<span class='warning'>\The [src] is too full.</span>"
			return
		var/obj/item/stack/S = W
		var/space_left = max_stored_matter - stored_matter
		var/sheets_to_take = min(S.amount, Floor(space_left/matter_amount_per_sheet))
		if(sheets_to_take <= 0)
			user << "<span class='warning'>\The [src] is too full.</span>"
			return
		stored_matter = min(max_stored_matter, stored_matter + (sheets_to_take*matter_amount_per_sheet))
		user << "<span class='info'>\The [src] processes \the [W]. Levels of stored matter now: [stored_matter]</span>"
		S.use(sheets_to_take)
		return
	return ..()
// END ROBOT ORGAN PRINTER

// FLESH ORGAN PRINTER
/obj/machinery/organ_printer/flesh
	name = "bioprinter"
	desc = "It's a machine that prints replacement organs."
	icon_state = "bioprinter"

	var/amount_per_slab = 50
	var/loaded_dna //Blood sample for DNA hashing.

/obj/machinery/organ_printer/flesh/mapped/initialize()
	..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/flesh/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		while(stored_matter >= amount_per_slab)
			stored_matter -= amount_per_slab
			new /obj/item/weapon/reagent_containers/food/snacks/meat(T)
	return ..()

/obj/machinery/organ_printer/flesh/New()
	..()
	component_parts += new /obj/item/device/healthanalyzer
	component_parts += new /obj/item/weapon/circuitboard/bioprinter

/obj/machinery/organ_printer/flesh/print_organ(var/choice)
	var/obj/item/organ/O = ..()
	if(loaded_dna)
		O.transplant_data = list()
		var/mob/living/carbon/C = loaded_dna["donor"]
		O.transplant_data["species"] =    C.species.name
		O.transplant_data["blood_type"] = loaded_dna["blood_type"]
		O.transplant_data["blood_DNA"] =  loaded_dna["blood_DNA"]
		visible_message("<span class='info'>\The [src] churns for a moment, injects its stored DNA into the biomass, then spits out \a [O].</span>")
	else
		visible_message("<span class='info'>\The [src] churns for a moment, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/flesh/attackby(obj/item/weapon/W, mob/user)
	// Load with matter for printing.
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat))
		if((max_stored_matter - stored_matter) < amount_per_slab)
			user << "<span class='warning'>\The [src] is too full.</span>"
			return
		stored_matter += amount_per_slab
		user.drop_item()
		user << "<span class='info'>\The [src] processes \the [W]. Levels of stored biomass now: [stored_matter]</span>"
		qdel(W)
		return
	// DNA sample from syringe.
	else if(istype(W,/obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			user << "<span class='info'>You inject the blood sample into the bioprinter.</span>"
		return
	return ..()
// END FLESH ORGAN PRINTER
