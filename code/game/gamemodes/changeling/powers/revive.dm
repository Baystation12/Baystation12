//Revive from revival stasis
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	var/datum/changeling/changeling = changeling_power(0,0,100,DEAD)
	if(!changeling)
		return 0

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		to_chat(src, "<span class='danger'>You have no genomes, not even your own, and cannot revive.</span>")
		return 0

	var/mob/living/carbon/C = src

	C.timeofdeath = null
	C.setToxLoss(0)
	C.setOxyLoss(0)
	C.setCloneLoss(0)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.radiation = 0
	C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
	C.reagents.clear_reagents()
	if(ishuman(C))
		var/mob/living/carbon/human/H = src
		H.species.create_organs(H)
		H.restore_all_organs(ignore_prosthetic_prefs=1) //Covers things like fractures and other things not covered by the above.
		H.restore_blood()
		H.mutations.Remove(MUTATION_HUSK)
		H.status_flags &= ORGAN_DISFIGURED
		H.UpdateAppearance()
		for(var/limb in H.organs_by_name)
			var/obj/item/organ/external/current_limb = H.organs_by_name[limb]
			if(current_limb)
				current_limb.dislocated = FALSE

		BITSET(H.hud_updateflag, HEALTH_HUD)
		BITSET(H.hud_updateflag, STATUS_HUD)
		BITSET(H.hud_updateflag, LIFE_HUD)

		if(H.handcuffed)
			var/obj/item/weapon/W = H.handcuffed
			H.handcuffed = null
			if(H.buckled && H.buckled.buckle_require_restraints)
				H.buckled.unbuckle_mob()
			H.drop_from_inventory(H.handcuffed)
			if (H.client)
				H.client.screen -= W
			W.forceMove(H.loc)
			W.dropped(H)
			if(W)
				W.layer = initial(W.layer)
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			var/obj/item/clothing/suit/straight_jacket/SJ = H.wear_suit
			SJ.forceMove(H.loc)
			SJ.dropped(H)
			H.wear_suit = null

	C.setHalLoss(0)
	to_chat(C, "<span class='notice'>We have regenerated.</span>")
	C.UpdateLyingBuckledAndVerbStatus()
	C.mind.changeling.purchased_powers -= C
	C.set_stat(CONSCIOUS)
	C.timeofdeath = null
	verbs.Remove(/mob/proc/changeling_revive)
	// re-add our changeling powers
	C.make_changeling()

	return TRUE

//Revive from revival stasis, but one level removed, as the tab refuses to update. Placed in its own tab to avoid hyper-exploding the original tab through the same name being used.

/obj/changeling_revive_holder
	name = "strange object"
	desc = "Please report this object's existence to the dev team! You shouldn't see it."
	mouse_opacity = FALSE
	alpha = 1

/obj/changeling_revive_holder/verb/ling_revive()
	set src = usr.contents
	set category = "Regenerate"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.changeling_revive()

	qdel(src)
