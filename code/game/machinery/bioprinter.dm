//These machines are mostly just here for debugging/spawning. Skeletons of the feature to come.

/obj/machinery/bioprinter
	name = "organ bioprinter"
	desc = "It's a machine that grows replacement organs."
	icon = 'icons/obj/surgery.dmi'

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 40

	icon_state = "bioprinter"

	var/prints_prosthetics
	var/stored_matter = 200
	var/loaded_dna //Blood sample for DNA hashing.
	var/list/products = list(
		"heart" =   list(/obj/item/organ/heart,  50),
		"lungs" =   list(/obj/item/organ/lungs,  40),
		"kidneys" = list(/obj/item/organ/kidneys,20),
		"eyes" =    list(/obj/item/organ/eyes,   30),
		"liver" =   list(/obj/item/organ/liver,  50)
		)

/obj/machinery/bioprinter/prosthetics
	name = "prosthetics fabricator"
	desc = "It's a machine that prints prosthetic organs."
	prints_prosthetics = 1

/obj/machinery/bioprinter/attack_hand(mob/user)

	var/choice = input("What would you like to print?") as null|anything in products
	if(!choice)
		return

	if(stored_matter >= products[choice][2])

		stored_matter -= products[choice][2]
		var/new_organ = products[choice][1]
		var/obj/item/organ/O = new new_organ(get_turf(src))

		if(prints_prosthetics)
			O.robotic = 2
		else if(loaded_dna)
			visible_message("<span class='notice'>The printer injects the stored DNA into the biomass.</span>.")
			O.transplant_data = list()
			var/mob/living/carbon/C = loaded_dna["donor"]
			O.transplant_data["species"] =    C.species.name
			O.transplant_data["blood_type"] = loaded_dna["blood_type"]
			O.transplant_data["blood_DNA"] =  loaded_dna["blood_DNA"]

		visible_message("<span class='info'>The bioprinter spits out a new organ.</span>")

	else
		user << "<span class='warning'>There is not enough matter in the printer.</span>"

/obj/machinery/bioprinter/attackby(obj/item/weapon/W, mob/user)

	// DNA sample from syringe.
	if(!prints_prosthetics && istype(W,/obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			user << "<span class='info'>You inject the blood sample into the bioprinter.</span>"
		return
	// Meat for biomass.
	if(!prints_prosthetics && istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat))
		stored_matter += 50
		user.drop_item()
		user << "<span class='info'>\The [src] processes \the [W]. Levels of stored biomass now: [stored_matter]</span>"
		qdel(W)
		return
	// Steel for matter.
	if(prints_prosthetics && istype(W, /obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL)
		var/obj/item/stack/S = W
		stored_matter += S.amount * 10
		user.drop_item()
		user << "<span class='info'>\The [src] processes \the [W]. Levels of stored matter now: [stored_matter]</span>"
		qdel(W)
		return
	
	return..()