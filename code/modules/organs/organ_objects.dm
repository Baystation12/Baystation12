/obj/item/organ
	icon = 'icons/mob/human_races/r_human.dmi'
	health = 100                              // Process() ticks before death.

	var/part                                  // Part represented.
	var/robotic = 0                           // Prosthetic or not.
	var/fresh = 3                             // Squirts of blood left in it.
	var/prosthetic_name = "prosthetic organ"  // Flavour string for robotic organ.

/obj/item/organ/New(loc, mob/living/carbon/human/H, var/spawn_robotic)
	..(loc)
	if(!istype(H))
		return
	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type
	// Is this item prosthetic?
	if(spawn_robotic)
		robotic = 1
		processing_objects += src
		if(prosthetic_name)
			name = prosthetic_name
		else
			name = "robotic [name]"

/obj/item/organ/Del()
	if(!robotic) processing_objects -= src
	..()

/obj/item/organ/proc/die()
	name = "dead [initial(name)]"
	health = 0
	processing_objects -= src
	//TODO: Grey out the icon state.
	//TODO: Inject an organ with peridaxon to make it alive again.

/obj/item/organ/process()

	if(robotic)
		processing_objects -= src
		return

	// Don't process if we're in a freezer, an MMI or a stasis bag. //TODO: ambient temperature?
	if(istype(loc,/obj/item/device/mmi) || istype(loc,/obj/item/bodybag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer))
		return

	if(fresh && prob(40))
		fresh--
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		blood_splatter(src,B,1)

	health -= rand(1,3)
	if(health <= 0)
		die()