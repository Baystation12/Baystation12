//Revive from revival stasis
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	var/datum/changeling/changeling = changeling_power(0,0,100,DEAD)
	if(!changeling)
		return 0

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		src << "<span class='danger'>You have no genomes, not even your own, and cannot revive.</span>"
		return 0

	var/mob/living/carbon/C = src

	C.tod = null
	C.setToxLoss(0)
	C.setOxyLoss(0)
	C.setCloneLoss(0)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.radiation = 0
	C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
	C.reagents.clear_reagents()
	C.restore_all_organs(ignore_prosthetic_prefs=1) //Covers things like fractures and other things not covered by the above.
	if(ishuman(C))
		var/mob/living/carbon/human/H = src
		H.restore_blood()
		H.mutations.Remove(HUSK)
		H.update_body(1)
		for(var/limb in H.organs_by_name)
			var/obj/item/organ/external/current_limb = H.organs_by_name[limb]
			current_limb.disfigured = 0
			current_limb.undislocate()

	C.halloss = 0
	C.shock_stage = 0 //Pain
	C << "<span class='notice'>We have regenerated.</span>"
	C.update_canmove()
	C.mind.changeling.purchased_powers -= C
	feedback_add_details("changeling_powers","CR")
	C.stat = CONSCIOUS
	C.timeofdeath = null
	C.switch_from_dead_to_living_mob_list()

	src.verbs -= /mob/proc/changeling_revive
	// re-add our changeling powers
	C.make_changeling()
	return 1
