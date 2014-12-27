/obj/item/organ
	icon = 'icons/mob/human_races/r_human.dmi'
	health = 100                              // Process() ticks before death.

	var/body_part                             // Part represented.
	var/robotic = 0                           // Prosthetic or not.
	var/fresh = 3                             // Squirts of blood left in it.
	var/prosthetic_name = "prosthetic organ"  // Flavour string for robotic organ.
	var/mob/living/carbon/human/owner
	var/status = 0
	var/vital //Lose a vital limb, die immediately.
	var/parent_organ

	var/damage = 0
	var/min_organ_damage = 0
	var/min_bruised_damage = 0
	var/min_broken_damage = 30

	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
									  // links chemical IDs to number of ticks for which they'll stay in the blood

/obj/item/organ/New(var/newloc, var/mob/living/carbon/H, var/spawn_robotic)
	..(newloc)
	owner = H
	if(!istype(H))
		return
	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type

	if(owner)
		processing_objects |= src

	// Is this item prosthetic?
	if(spawn_robotic)
		robotic = 1
		if(prosthetic_name)
			name = prosthetic_name
		else
			name = "robotic [name]"

/obj/item/organ/proc/take_damage()
	return

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/get_icon(var/icon/race_icon, var/icon/deform_icon)
	return icon('icons/mob/human.dmi',"blank")

//Germs
/obj/item/organ/proc/handle_antibiotics()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (!germ_level || antibiotics < 5)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 6	//at germ_level == 500, this should cure the infection in a minute
	else
		germ_level -= 2 //at germ_level == 1000, this will cure the infection in 5 minutes

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

/obj/item/organ/Del()
	if(!robotic) processing_objects -= src
	..()

/obj/item/organ/proc/die()
	name = "dead [initial(name)]"
	health = 0
	processing_objects -= src
	//TODO: Grey out the icon state.
	//TODO: Inject an organ with peridaxon to make it alive again.

/obj/item/organ/proc/process_internal()
	return

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

/obj/item/organ/emp_act(severity)
	switch(robotic)
		if(0)
			return
		if(1)
			switch (severity)
				if (1.0)
					take_damage(20,0)
					return
				if (2.0)
					take_damage(7,0)
					return
				if(3.0)
					take_damage(3,0)
					return
		if(2)
			switch (severity)
				if (1.0)
					take_damage(40,0)
					return
				if (2.0)
					take_damage(15,0)
					return
				if(3.0)
					take_damage(10,0)
					return