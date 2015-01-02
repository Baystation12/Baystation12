/obj/item/organ
	icon = 'icons/mob/human_races/r_human.dmi'
	health = 50
	var/max_health = 0

	var/body_part                             // Part represented.
	var/mob/living/carbon/human/owner
	var/status = 0
	var/vital //Lose a vital limb, die immediately.
	var/parent_organ
	var/rejecting = 0

	var/brute_dam = 0
	var/burn_dam = 0

	var/min_organ_damage = 0
	var/min_bruised_damage = 15
	var/min_broken_damage = 30

	var/list/transplant_data = list()                 // Stores info when removed.
	var/list/datum/autopsy_data/autopsy_data = list() // Keeps track of trace chems and weapon damage.
	var/list/trace_chemicals = list()                 // links chemical IDs to number of ticks for which they'll stay in the blood

/obj/item/organ/New(var/mob/living/carbon/H, var/spawn_robotic)
	..()
	max_health = initial(health)
	create_reagents(5)

	if(!H && istype(loc,/turf))
		processing_objects |= src
	else
		germ_level = 0

	if(!istype(H)) //Stopgap to stop runtimes filling up log during testing
		del(src) // remove before merge

	owner = H
	transplant_data = list()
	var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!organ_blood)
		if(owner)
			transplant_data["species"] = owner.species.name
			if(!owner.vessel)
				owner.make_blood()
			owner.vessel.trans_to(src, 5, 1, 1)
	if(owner && owner.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[owner.dna.unique_enzymes] = owner.dna.b_type
		transplant_data["blood_type"] = owner.dna.b_type
		transplant_data["blood_DNA"] =  owner.dna.unique_enzymes

	// Is this item prosthetic?
	if(spawn_robotic)
		roboticize()

/obj/item/organ/proc/removed(var/mob/living/user)

	germ_level = max(GERM_LEVEL_AMBIENT,germ_level)
	src.status &= ~(ORGAN_BROKEN|ORGAN_BLEEDING|ORGAN_SPLINTED|ORGAN_DEAD)

	var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!organ_blood)
		owner.vessel.trans_to(src, 5, 1, 1)

		transplant_data = list()
		if(owner.dna)
			transplant_data["blood_type"] = owner.dna.b_type
			transplant_data["blood_DNA"] =  owner.dna.unique_enzymes
		transplant_data["species"] =    owner.species.name

	var/turf/target_loc
	if(user)
		target_loc = get_turf(user)
	else
		target_loc = get_turf(owner)
	loc = target_loc

	if(!(status & ORGAN_ROBOT))
		processing_objects |= src

	if(vital)
		owner.death()

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/Del()
	if(!(status & ORGAN_ROBOT))
		processing_objects -= src
	..()

/obj/item/organ/proc/process_internal()
	return

/obj/item/organ/process()

	if(status & (ORGAN_ROBOT|ORGAN_DEAD))
		processing_objects -= src
		return 0

	// Don't process if we're in a freezer, an MMI or a stasis bag. //TODO: ambient temperature?
	if(istype(loc,/obj/item/device/mmi) || istype(loc,/obj/item/bodybag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer))
		return 0

	if(health && prob(40))
		take_damage(rand(1,3),0)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		blood_splatter(src,B,1)
	return 1

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	owner = target
	src.loc = target

/obj/item/organ/proc/sync_with(var/mob/living/carbon/human/target)
	owner = target
	transplant_data = list()
	if(owner.dna)
		transplant_data["blood_type"] = owner.dna.b_type
		transplant_data["blood_DNA"] =  owner.dna.unique_enzymes
	transplant_data["species"] = owner.species.name
	rejecting = 0

/mob/living/carbon/human/proc/sync_organs()
	for(var/obj/item/organ/organ in organs)
		organ.sync_with(src)