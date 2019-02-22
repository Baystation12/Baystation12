/datum/chemical_reaction/nullglass
	name = "Soulstone"
	result = null
	required_reagents = list(/datum/reagent/blood = 15, /datum/reagent/crystal = 1)
	result_amount = 1

/datum/chemical_reaction/nullglass/get_reaction_flags(var/datum/reagents/holder)
	for(var/datum/reagent/blood/blood in holder.reagent_list)
		var/weakref/donor_ref = islist(blood.data) && blood.data["donor"]
		if(istype(donor_ref))
			var/mob/living/donor = donor_ref.resolve()
			if(istype(donor) && (donor.psi || (donor.mind && GLOB.wizards.is_antagonist(donor.mind))))
				return TRUE

/datum/chemical_reaction/nullglass/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	var/location = get_turf(holder.my_atom)
	if(reaction_flags)
		for(var/i = 1, i <= created_volume, i++)
			new /obj/item/device/soulstone(location)
	else
		for(var/i = 1, i <= created_volume*2, i++)
			new /obj/item/weapon/material/shard(location, MATERIAL_CRYSTAL)

/datum/reagent/crystal
	name = "crystallizing agent"
	taste_description = "sharpness"
	reagent_state = LIQUID
	color = "#13bc5e"

/datum/reagent/crystal/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/result_mat = (M.psi || (M.mind && GLOB.wizards.is_antagonist(M.mind))) ? MATERIAL_NULLGLASS : MATERIAL_CRYSTAL
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(5))
			var/obj/item/organ/external/E = pick(H.organs)
			if(!E || E.is_stump() || BP_IS_ROBOTIC(E))
				return
			if(BP_IS_CRYSTAL(E))
				if((E.brute_dam + E.burn_dam) > 0)
					if(prob(15))
						to_chat(M, SPAN_NOTICE("You feel a crawling sensation as fresh crystal grows over your [E.name]."))
					E.heal_damage(rand(3,5), rand(3,5))
				if(BP_IS_BRITTLE(E) && prob(5))
					E.status &= ~ORGAN_BRITTLE
			else if(E.organ_tag != BP_CHEST && E.organ_tag != BP_GROIN)
				to_chat(H, SPAN_DANGER("Your [E.name] is being lacerated from within!"))
				if(H.can_feel_pain())
					H.emote("scream")
				if(prob(25))
					for(var/i = 1 to rand(3,5))
						new /obj/item/weapon/material/shard(get_turf(E), result_mat)
					E.droplimb(0, DROPLIMB_BLUNT)
				else
					E.take_external_damage(rand(20,30), 0)
					E.status |= ORGAN_CRYSTAL
					E.status |= ORGAN_BRITTLE
	else
		to_chat(M, SPAN_DANGER("Your flesh is being lacerated from within!"))
		M.adjustBruteLoss(rand(3,6))
		if(prob(10))
			new /obj/item/weapon/material/shard(get_turf(M), result_mat)
