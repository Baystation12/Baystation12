//had to make this because restore_all_organs just does a full heal, which we don't want.
/obj/item/organ/external/proc/ling_organ_rejuvenate(ignore_prosthetic_prefs)

	// handle internal organs. Heavily debating making this just fix some of the damage since a full heal might be much? idk
	for(var/obj/item/organ/current_organ in internal_organs)
		current_organ.rejuvenate(ignore_prosthetic_prefs)

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant,) || istype(implanted_object,/obj/item/organ/internal/augment))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(get_turf(src))
			implants -= implanted_object

	if(owner && !ignore_prosthetic_prefs)
		if(owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
			var/status = owner.client.prefs.organ_data[organ_tag]
			if(status == "amputated")
				remove_rejuv()
		owner.updatehealth()
	if(status & ORGAN_ARTERY_CUT)
		status &= ~ORGAN_ARTERY_CUT
	if(status & ORGAN_TENDON_CUT)
		status &= ~ORGAN_TENDON_CUT
	if(status & ORGAN_BROKEN)
		status &= ~ORGAN_BROKEN
		stage = 0
	if(!QDELETED(src) && species)
		species.post_organ_rejuvenate(src, owner)
/mob/living/carbon/human/proc/ling_heal_single_organ(ignore_prosthetic_prefs)
	for(var/bodypart in BP_BY_DEPTH)
		var/obj/item/organ/external/current_organ = organs_by_name[bodypart]
		//checks if the limb has been twisted/hurt/affected and if it has, fixes it
		if(istype(current_organ) && (current_organ.status != initial(current_organ.status) && !(BP_IS_ROBOTIC(current_organ))))
			current_organ.ling_organ_rejuvenate(ignore_prosthetic_prefs)
			return
	verbs -= /mob/living/carbon/human/proc/undislocate
/datum/power/changeling/rapid_regen
	name = "Rapid Regeneration"
	desc = "We quickly heal ourselves, removing most advanced injuries, at a high chemical cost. We cannot regenerate lost limbs however."
	helptext = "We will begin to regenerate our flesh, healing ourselves of brute, burn, oxygen and brain damage, as well as mending internal organs, broken bones, \
	and organ damage.  The process is fast, but we must remain still and anyone who sees us will know us for what we are."
	enhancedtext = "Healing increased to heal up to maximum health."
	ability_icon_state = "ling_rapid_regeneration"
	genomecost = 2
	verbpath = /mob/proc/changeling_rapid_regen

//Gives a big heal, removing various injuries that might shut down normal people, like IB or fractures.
/mob/proc/changeling_rapid_regen()
	set category = "Changeling"
	set name = "Rapid Regeneration (30 per tick)"
	set desc = "Heal ourselves of most injuries rapidly."
	set waitfor = FALSE
	var/finish_regen = TRUE
	var/datum/changeling/changeling = changeling_power(30,0,100,UNCONSCIOUS)
	if(!changeling)
		return


	if(ishuman(src))
		var/mob/living/carbon/human/C = src
		if(C.on_fire)
			to_chat(src,SPAN_DANGER("We cannot regenerate while engulfed in flames!"))
			return
		if(changeling.already_regenerating)
			to_chat(src,SPAN_DANGER("We are already regenerating our flesh."))
			return
		var/healing_amount = 40
		if(src.mind.changeling.recursive_enhancement)
			src.mind.changeling.recursive_enhancement = FALSE
			healing_amount = 80
			to_chat(src, SPAN_NOTICE("Our regeneration will be stronger."))
		if(src.mind.changeling.chem_charges < 30)
			to_chat(src,SPAN_WARNING("We require at least 10 chemicals to regenerate!"))
			return
		to_chat(src,SPAN_NOTICE("We begin to regenerate our form. We must remain still to complete the process."))
		changeling.already_regenerating = TRUE
		while((src.mind.changeling.chem_charges >= 30))

			finish_regen = do_mob(C,C,5 SECONDS,ignore_movement = FALSE, incapacitation_affected = FALSE)

			if(finish_regen)
				C.adjustBruteLoss(-healing_amount)
				C.adjustFireLoss(-healing_amount)
				C.adjustOxyLoss(-healing_amount)
				C.adjustToxLoss(-healing_amount)
				C.adjustCloneLoss(-healing_amount)
				C.adjustBrainLoss(-healing_amount)
				C.regenerate_blood(healing_amount*2)
				C.ling_heal_single_organ()
				C.blinded = 0
				C.eye_blind = 0
				C.eye_blurry = 0
				C.ear_deaf = 0
				C.ear_damage = 0

				// make the icons look correct
				C.regenerate_icons()

				// now make it obvious that we're not human (or whatever xeno race they are impersonating)
				playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
				var/T = get_turf(src)
				new /obj/gibspawner/human(T)

			else
				to_chat(src,SPAN_WARNING("Our regeneration is brought to a halt by us moving!"))
				changeling.already_regenerating = FALSE
				return

			src.mind.changeling.chem_charges -= 30
		changeling.already_regenerating = FALSE
