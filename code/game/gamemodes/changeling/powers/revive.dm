//Revive from revival stasis
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	var/datum/changeling/changeling = changeling_power(0,0,100,DEAD)
	if(!changeling)
		return 0

	if(src.stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
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
	C.restore_all_organs() //Covers things like fractures and other things not covered by the above.
	if(ishuman(C))
		var/mob/living/carbon/human/H = src
		H.restore_blood()
	C << "<span class='notice'>We have regenerated.</span>"
	C.status_flags &= ~(FAKEDEATH)
	C.update_canmove()
	C.mind.changeling.purchasedpowers -= C
	feedback_add_details("changeling_powers","CR")
	C.stat = CONSCIOUS
	src.verbs -= /mob/proc/changeling_revive
	// re-add our changeling powers
	C.make_changeling()
	return 1