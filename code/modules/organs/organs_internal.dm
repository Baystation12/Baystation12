/obj/item/organ/internal
	name = "organ"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"

	var/dead_icon // Icon used when the organ dies.

/obj/item/organ/internal/attack_self(mob/user as mob)

	// Convert it to an edible form, yum yum.
	if((status & ORGAN_ROBOT) && user.a_intent == "help" && user.zone_sel.selecting == "mouth")
		bitten(user)
		return

/obj/item/organ/internal/New()
	..()
	if(istype(owner))
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(E)
			if(E.internal_organs == null)
				E.internal_organs = list()
			E.internal_organs |= src

/obj/item/organ/internal/removed(var/mob/living/user)

	..()

	if(!istype(owner))
		return

	owner.internal_organs_by_name[body_part] = null
	owner.internal_organs_by_name -= body_part
	owner.internal_organs -= src

	var/obj/item/organ/external/affected = owner.get_organ(src.parent_organ)
	affected.internal_organs -= src

	loc = owner.loc
	rejecting = 0

	if(owner && user && vital)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [owner.name] ([owner.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		owner.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [owner.name] ([owner.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		owner.death()

/obj/item/organ/internal/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!transplant_blood)
		transplant_data = list()
		transplant_data["species"] =    target.species.name
		transplant_data["blood_type"] = target.dna.b_type
		transplant_data["blood_DNA"] =  target.dna.unique_enzymes
	else
		transplant_data = list()
		transplant_data["species"] =    transplant_blood.data["species"]
		transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	owner = target
	src.loc = owner
	if(!(status & ORGAN_ROBOT))
		processing_objects -= src
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[body_part] = src
	status |= ORGAN_CUT_AWAY

/obj/item/organ/internal/proc/bitten(mob/user)

	if(status & ORGAN_ROBOT)
		return

	user << "<span class='notice'>You take an experimental bite out of \the [src].</span>"
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)

	user.drop_from_inventory(src)
	var/obj/item/weapon/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon_state = dead_icon ? dead_icon : icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints) O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden) O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast) O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	del(src)

/obj/item/organ/internal/process_internal()

	..()

	//Process infections
	if (status & ORGAN_ROBOT)
		germ_level = 0
		return

	if(owner.bodytemperature < 170)	//cryo stops germs from moving and doing their bad stuffs
		return

	//** Handle antibiotics and curing infections
	handle_antibiotics()

	//** Handle the effects of infections
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(antibiotics < 5 && prob(round(germ_level/6)))
			germ_level++

	if (germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_damage(1,0)

	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(transplant_data)
		if(rejecting > 0 || (prob(20) && owner.dna && blood_incompatible(transplant_data["blood_type"],owner.dna.b_type,owner.species.name,transplant_data["species"])))
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						take_damage(1)
					if(51 to 200)
						owner.reagents.add_reagent("toxin", 1)
						take_damage(1)
					if(201 to 500)
						take_damage(rand(2,3))
						owner.reagents.add_reagent("toxin", 2)
					if(501 to INFINITY)
						take_damage(4)
						owner.reagents.add_reagent("toxin", rand(3,5))