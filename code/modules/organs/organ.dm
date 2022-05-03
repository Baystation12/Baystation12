var/global/list/organ_cache = list()

/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	w_class = ITEM_SIZE_TINY
	default_action_type = /datum/action/item_action/organ

	// Strings.
	var/organ_tag = "organ"           // Unique identifier.
	var/parent_organ = BP_CHEST       // Organ holding this object.

	// Status tracking.
	var/status = 0                    // Various status flags (such as robotic)
	var/vital                         // Lose a vital limb, die immediately.

	// Reference data.
	var/mob/living/carbon/human/owner // Current mob owning the organ.
	var/datum/dna/dna                 // Original DNA.
	var/datum/species/species         // Original species.

	// Damage vars.
	var/damage = 0                    // Current damage to the organ
	var/min_broken_damage = 30        // Damage before becoming broken
	var/max_damage = 30               // Damage cap
	var/rejecting                     // Is this organ already being rejected?

	var/death_time

	// Bioprinter stats
	var/can_be_printed = TRUE
	var/print_cost

/obj/item/organ/Destroy()
	owner = null
	dna = null
	return ..()

/obj/item/organ/proc/refresh_action_button()
	return action

/obj/item/organ/attack_self(var/mob/user)
	return (owner && loc == owner && owner == user)

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Second argument may be a dna datum; if null will be set to holder's dna.
/obj/item/organ/New(var/mob/living/carbon/holder, var/datum/dna/given_dna)
	..(holder)
	if(!istype(given_dna))
		given_dna = null

	if(max_damage)
		min_broken_damage = Floor(max_damage / 2)
	else
		max_damage = min_broken_damage * 2

	if(istype(holder))
		owner = holder
		if(!given_dna && holder.dna)
			given_dna = holder.dna
		else
			log_debug("[src] spawned in [holder] without a proper DNA.")

	if (given_dna)
		set_dna(given_dna)
	if (!species)
		species = all_species[SPECIES_HUMAN]
	species.resize_organ(src)

	create_reagents(5 * (w_class-1)**2)
	reagents.add_reagent(/datum/reagent/nutriment/protein, reagents.maximum_volume)

	update_icon()

/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA.Cut()
		blood_DNA[dna.unique_enzymes] = dna.b_type
		species = all_species[dna.species]
		if (!species)
			crash_with("Invalid DNA species. Expected a valid species name as string, was: [log_info_line(dna.species)]")

/obj/item/organ/proc/die()
	damage = max_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSobj, src)
	death_time = world.time
	if(owner && vital)
		owner.death()

/obj/item/organ/Process()

	if(loc != owner)
		owner = null

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()
		return

	//Process infections
	if (BP_IS_ROBOTIC(src) || (owner && owner.species && (owner.species.species_flags & SPECIES_FLAG_IS_PLANT)))
		germ_level = 0
		return

	// Don't process if we're in a freezer, an MMI or a stasis bag.or a freezer or something I dunno
	if(is_preserved())
		return

	if(!owner && reagents)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		if(B && prob(40))
			reagents.remove_reagent(/datum/reagent/blood,0.1)
			blood_splatter(src,B,1)
		if(config.organs_decay)
			take_general_damage(rand(1,3))
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

	else if(owner && owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

/obj/item/organ/proc/is_preserved()
	if(istype(loc,/obj/item/organ))
		var/obj/item/organ/O = loc
		return O.is_preserved()
	else
		return (istype(loc,/obj/item/device/mmi) || istype(loc,/obj/structure/closet/body_bag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer) || istype(loc,/obj/item/storage/box/freezer))

/obj/item/organ/examine(mob/user)
	. = ..(user)
	show_decay_status(user)

/obj/item/organ/proc/show_decay_status(mob/user)
	if(status & ORGAN_DEAD)
		to_chat(user, "<span class='notice'>The decay has set into \the [src].</span>")

/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/virus_immunity = owner.virus_immunity() //reduces the amount of times we need to call this proc
	var/antibiotics = owner.reagents.get_reagent_amount(/datum/reagent/spaceacillin)

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(virus_immunity*0.3))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes, when immunity is full.
		if(antibiotics < 5 && prob(round(germ_level/6 * owner.immunity_weakness() * 0.01)))
			if(virus_immunity > 0)
				germ_level += clamp(round(1/virus_immunity), 1, 10) // Immunity starts at 100. This doubles infection rate at 50% immunity. Rounded to nearest whole.
			else // Will only trigger if immunity has hit zero. Once it does, 10x infection rate.
				germ_level += 10

	if(germ_level >= INFECTION_LEVEL_ONE)
		var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		owner.bodytemperature += clamp((fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, 0, fever_temperature - owner.bodytemperature)

	if (germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(owner.immunity_weakness() * 0.3) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_general_damage(1,silent=prob(30))

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(owner.virus_immunity() < 10) //for now just having shit immunity will suppress it
		return
	if(BP_IS_ROBOTIC(src))
		return
	if(dna)
		if(!rejecting)
			if(owner.blood_incompatible(dna.b_type, species))
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						germ_level++
					if(51 to 200)
						germ_level += rand(1,2)
					if(201 to 500)
						germ_level += rand(2,3)
					if(501 to INFINITY)
						germ_level += rand(3,5)
						owner.reagents.add_reagent(/datum/reagent/toxin, rand(1,2))

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/remove_rejuv()
	qdel(src)

/obj/item/organ/proc/rejuvenate(var/ignore_prosthetic_prefs)
	damage = 0
	status = initial(status)
	if(!ignore_prosthetic_prefs && owner && owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
		var/status = owner.client.prefs.organ_data[organ_tag]
		if(status == "assisted")
			mechassist()
		else if(status == "mechanical")
			robotize()
	if(species)
		species.post_organ_rejuvenate(src, owner)

//Germs
/obj/item/organ/proc/handle_antibiotics()
	if(!owner || !germ_level)
		return

	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]
	if (!antibiotics)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 5	//at germ_level == 500, this should cure the infection in 5 minutes
	else
		germ_level -= 3 //at germ_level == 1000, this will cure the infection in 10 minutes
	if(owner && owner.lying)
		germ_level -= 2
	germ_level = max(0, germ_level)

/obj/item/organ/proc/take_general_damage(var/amount, var/silent = FALSE)
	CRASH("Not Implemented")

/obj/item/organ/proc/heal_damage(amount)
	if (can_recover())
		damage = clamp(damage - round(amount, 0.1), 0, max_damage)


/obj/item/organ/proc/robotize() //Being used to make robutt hearts, etc
	status = ORGAN_ROBOTIC

/obj/item/organ/proc/mechassist() //Used to add things like pacemakers, etc
	status = ORGAN_ASSISTED

/**
 *  Remove an organ
 *
 *  drop_organ - if true, organ will be dropped at the loc of its former owner
 *
 *  Also, Observer Pattern Implementation: Dismembered Handling occurs here.
 */
/obj/item/organ/proc/removed(var/mob/living/user, var/drop_organ=1)

	if(!istype(owner))
		return
	GLOB.dismembered_event.raise_event(owner, src)

	action_button_name = null

	if(drop_organ)
		dropInto(owner.loc)

	START_PROCESSING(SSobj, src)
	rejecting = null
	if(!BP_IS_ROBOTIC(src))
		var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list //TODO fix this and all other occurences of locate(/datum/reagent/blood) horror
		if(!organ_blood || !organ_blood.data["blood_DNA"])
			owner.vessel.trans_to(src, 5, 1, 1)

	if(owner && vital)
		if(user)
			admin_attack_log(user, owner, "Removed a vital organ ([src]).", "Had a vital organ ([src]) removed.", "removed a vital organ ([src]) from")
		owner.death()

	owner = null

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	owner = target
	action_button_name = initial(action_button_name)
	forceMove(owner) //just in case
	if(BP_IS_ROBOTIC(src))
		set_dna(owner.dna)
	return 1

/obj/item/organ/attack(var/mob/target, var/mob/user)

	if(status & ORGAN_ROBOTIC || !istype(target) || !istype(user) || (user != target && user.a_intent == I_HELP))
		return ..()

	if(alert("Do you really want to use this organ as food? It will be useless for anything else afterwards.",,"Ew, no.","Bon appetit!") == "Ew, no.")
		to_chat(user, "<span class='notice'>You successfully repress your cannibalistic tendencies.</span>")
		return
	if(!user.unEquip(src))
		return
	var/obj/item/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.SetName(name)
	O.appearance = src
	if(reagents && reagents.total_volume)
		reagents.trans_to(O, reagents.total_volume)
	transfer_fingerprints_to(O)
	user.put_in_active_hand(O)
	qdel(src)
	target.attackby(O, user)

/obj/item/organ/proc/can_feel_pain()
	return (!BP_IS_ROBOTIC(src) && (!species || !(species.species_flags & SPECIES_FLAG_NO_PAIN)))

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/proc/can_recover()
	return (max_damage > 0) && !(status & ORGAN_DEAD) || death_time >= world.time - ORGAN_RECOVERY_THRESHOLD

/obj/item/organ/proc/get_scan_results(var/tag = FALSE)
	. = list()
	if(BP_IS_CRYSTAL(src))
		. += tag ? "<span class='average'>Crystalline</span>" : "Crystalline"
	else if(BP_IS_ASSISTED(src))
		. += tag ? "<span class='average'>Assisted</span>" : "Assisted"
	else if(BP_IS_ROBOTIC(src))
		. += tag ? "<span class='average'>Mechanical</span>" : "Mechanical"
	if(status & ORGAN_CUT_AWAY)
		. += tag ? "<span class='bad'>Severed</span>" : "Severed"
	if(status & ORGAN_MUTATED)
		. += tag ? "<span class='bad'>Genetic Deformation</span>" : "Genetic Deformation"
	if(status & ORGAN_DEAD)
		if(can_recover())
			. += tag ? "<span class='bad'>Decaying</span>" : "Decaying"
		else
			. += tag ? "<span style='color:#999999'>Necrotic</span>" : "Necrotic"
	if(BP_IS_BRITTLE(src))
		. += tag ? "<span class='bad'>Brittle</span>" : "Brittle"

	switch (germ_level)
		if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + ((INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3))
			. +=  "Mild Infection"
		if (INFECTION_LEVEL_ONE + ((INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3) to INFECTION_LEVEL_ONE + (2 * (INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3))
			. +=  "Mild Infection+"
		if (INFECTION_LEVEL_ONE + (2 * (INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3) to INFECTION_LEVEL_TWO)
			. +=  "Mild Infection++"
		if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + ((INFECTION_LEVEL_THREE - INFECTION_LEVEL_THREE) / 3))
			if(tag)
				. += "<span class='average'>Acute Infection</span>"
			else
				. +=  "Acute Infection"
		if (INFECTION_LEVEL_TWO + ((INFECTION_LEVEL_THREE - INFECTION_LEVEL_THREE) / 3) to INFECTION_LEVEL_TWO + (2 * (INFECTION_LEVEL_THREE - INFECTION_LEVEL_TWO) / 3))
			if(tag)
				. += "<span class='average'>Acute Infection+</span>"
			else
				. +=  "Acute Infection+"
		if (INFECTION_LEVEL_TWO + (2 * (INFECTION_LEVEL_THREE - INFECTION_LEVEL_TWO) / 3) to INFECTION_LEVEL_THREE)
			if(tag)
				. += "<span class='average'>Acute Infection++</span>"
			else
				. +=  "Acute Infection++"
		if (INFECTION_LEVEL_THREE to INFINITY)
			if(tag)
				. += "<span class='bad'>Septic</span>"
			else
				. +=  "Septic"
	if(rejecting)
		if(tag)
			. += "<span class='bad'>Genetic Rejection</span>"
		else
			. += "Genetic Rejection"

//used by stethoscope
/obj/item/organ/proc/listen()
	return

/obj/item/organ/proc/get_mechanical_assisted_descriptor()
	return "mechanically-assisted [name]"


/**
* Pre-surgery modification of the organ if it has status|ORGAN_CONFIGURE
* Halts surgery if the return value is truthy
*/
/obj/item/organ/proc/surgery_configure(mob/living/user, mob/living/carbon/human/target, obj/item/organ/parent, obj/item/tool, decl/surgery_step/action)
	return
