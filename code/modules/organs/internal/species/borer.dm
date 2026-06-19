//CORTICAL BORER ORGANS.
/obj/item/organ/internal/borer
	name = "cortical borer"
	icon = 'icons/mob/simple_animal/animal.dmi'
	icon_state = "brainslug"
	organ_tag = BP_BRAIN
	desc = "A disgusting space slug."
	parent_organ = BP_HEAD
	vital = 1
	var/list/chemical_types

/obj/item/organ/internal/borer/Process()

	// Borer husks regenerate health, feel no pain, and are resistant to stuns and brainloss.
	if(owner && world.time % 6)
		owner.adjustBruteLoss(-1)
		owner.adjustFireLoss(-1)
		owner.adjustToxLoss(-1)
		owner.adjustOxyLoss(-1)
		owner.add_up_to_chemical_effect(CE_STABLE)
		owner.add_up_to_chemical_effect(CE_PAINKILLER, 160)

		for(var/obj/item/organ/internal/I in owner.internal_organs)
			if(!BP_IS_ROBOTIC(I))
				I.heal_damage(1)

		if(prob(5))
			owner.resuscitate()

	// They're also super gross and ooze ichor.
	if(prob(5))
		var/mob/living/carbon/human/H = owner
		if(!istype(H))
			return

		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
		blood_splatter(H,B,1)
		var/obj/decal/cleanable/blood/splatter/goo = locate() in get_turf(owner)
		if(goo)
			goo.SetName("husk ichor")
			goo.desc = "A thick goo that reeks of decay."
			goo.basecolor = "#412464"
			goo.update_icon()

/obj/item/organ/internal/borer/removed(mob/living/user)

	..()

	var/mob/living/simple_animal/borer/B = owner.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = owner.ckey

	spawn(0)
		qdel(src)
